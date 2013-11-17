//===--- ProtocolConformance.h - AST Protocol Conformance -------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// This file defines the protocol conformance data structures.
//
//===----------------------------------------------------------------------===//
#ifndef SWIFT_AST_PROTOCOLCONFORMANCE_H
#define SWIFT_AST_PROTOCOLCONFORMANCE_H

#include "swift/AST/ConcreteDeclRef.h"
#include "swift/AST/Substitution.h"
#include "swift/AST/Type.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/FoldingSet.h"
#include "llvm/ADT/SmallPtrSet.h"
#include <utility>

namespace swift {

class AssociatedTypeDecl;
class ASTContext;
class ProtocolConformance;
class ProtocolDecl;
class SubstitutableType;
class ValueDecl;
class Module;
  
/// \brief Type substitution mapping from substitutable types to their
/// replacements.
typedef llvm::DenseMap<SubstitutableType *, Type> TypeSubstitutionMap;

/// Map from non-type requirements to the corresponding conformance witnesses.
typedef llvm::DenseMap<ValueDecl *, ConcreteDeclRef> WitnessMap;

/// Map from associated type requirements to the corresponding substitution,
/// which captures the replacement type along with any conformances it requires.
typedef llvm::DenseMap<AssociatedTypeDecl *, Substitution> TypeWitnessMap;

/// Map from a directly-inherited protocol to its corresponding protocol
/// conformance.
typedef llvm::DenseMap<ProtocolDecl *, ProtocolConformance *>
  InheritedConformanceMap;

/// Describes the kind of protocol conformance structure used to encode
/// conformance.
enum class ProtocolConformanceKind {
  /// "Normal" conformance of a (possibly generic) nominal type, which
  /// contains complete mappings.
  Normal,
  /// Conformance for a specialization of a generic type, which projects the
  /// underlying generic conformance.
  Specialized,
  /// Conformance of a generic class type projected through one of its
  /// superclass's conformances.
  Inherited
};

/// \brief Describes how a particular type conforms to a given protocol,
/// providing the mapping from the protocol members to the type (or extension)
/// members that provide the functionality for the concrete type.
///
/// ProtocolConformance is an abstract base class, implemented by subclasses
/// for the various kinds of conformance (normal, specialized, inherited).
class ProtocolConformance {
  /// The kind of protocol conformance.
  ProtocolConformanceKind Kind;

  /// \brief The type that conforms to the protocol.
  Type ConformingType;

protected:
  ProtocolConformance(ProtocolConformanceKind kind, Type conformingType)
    : Kind(kind), ConformingType(conformingType) { }

public:
  /// Determine the kind of protocol conformance.
  ProtocolConformanceKind getKind() const { return Kind; }

  /// Get the conforming type.
  Type getType() const { return ConformingType; }

  /// Get the protocol being conformed to.
  ProtocolDecl *getProtocol() const;

  /// Get the module that contains the conforming extension or type declaration.
  Module *getContainingModule() const;

  /// Retrieve the type witness for the given associated type.
  const Substitution &getTypeWitness(AssociatedTypeDecl *assocType) const {
    const auto &typeWitnesses = getTypeWitnesses();
    auto known = typeWitnesses.find(assocType);
    assert(known != typeWitnesses.end());
    return known->second;
  }

  /// Retrieve the complete set of type witnesses.
  const TypeWitnessMap &getTypeWitnesses() const;

  /// Retrieve the non-type witness for the given requirement.
  ConcreteDeclRef getWitness(ValueDecl *requirement) const {
    const auto &witnesses = getWitnesses();
    auto known = witnesses.find(requirement);
    assert(known != witnesses.end());
    return known->second;
  }

  /// Retrieve the complete set of non-type witnesses.
  const WitnessMap &getWitnesses() const;

  /// Retrieve the protocol conformance for a directly-inherited protocol.
  ProtocolConformance *getInheritedConformance(ProtocolDecl *protocol) const {
    auto &inherited = getInheritedConformances();
    auto known = inherited.find(protocol);
    assert(known != inherited.end());
    return known->second;
  }

  /// Retrieve the complete set of protocol conformances for directly inherited
  /// protocols.
  const InheritedConformanceMap &getInheritedConformances() const;

  /// Determine whether the witness for the given requirement
  /// is either the default definition or was otherwise deduced.
  ///
  /// FIXME: This is a crummy API. This information should be recorded in the
  /// witnesses themselves.
  bool usesDefaultDefinition(ValueDecl *requirement) const;

  // Make vanilla new/delete illegal for protocol conformances.
  void *operator new(size_t bytes) = delete;
  void operator delete(void *data) = delete;

  // Only allow allocation of protocol conformances using the allocator in
  // ASTContext or by doing a placement new.
  void *operator new(size_t bytes, ASTContext &context,
                     unsigned alignment = alignof(ProtocolConformance));
  void *operator new(size_t bytes, void *mem) {
    assert(mem);
    return mem;
  }
};

/// Normal protocol conformance, which involves mapping each of the protocol
/// requirements to a witness.
///
/// Normal protocol conformance is used for the explicit conformances placed on
/// nominal types and extensions. For example:
///
/// \code
/// protocol P { func foo() }
/// struct A : P { func foo() { } }
/// class B<T> : P { func foo() { } }
/// \endcode
///
/// Here, there is a normal protocol conformance for both \c A and \c B<T>,
/// providing the witnesses \c A.foo and \c B<T>.foo, respectively, for the
/// requirement \c foo.
class NormalProtocolConformance : public ProtocolConformance {
  /// \brief The protocol being conformed to.
  ProtocolDecl *Protocol;

  /// \brief The module containing the ExtensionDecl or NominalTypeDecl that
  /// declared the conformance.
  Module *ContainingModule;

  /// \brief The mapping of individual requirements in the protocol over to
  /// the declarations that satisfy those requirements.
  WitnessMap Mapping;

  /// The mapping from associated type requirements to their substitutions.
  TypeWitnessMap TypeWitnesses;

  /// \brief The mapping from any directly-inherited protocols over to the
  /// protocol conformance structures that indicate how the given type meets
  /// the requirements of those protocols.
  InheritedConformanceMap InheritedMapping;

  /// The set of requirements for which we have used default definitions or
  /// otherwise deduced the result.
  llvm::SmallPtrSet<ValueDecl *, 4> DefaultedDefinitions;

  friend class ASTContext;

  NormalProtocolConformance(Type conformingType,
                            ProtocolDecl *protocol,
                            Module *containingModule,
                            WitnessMap &&witnesses,
                            TypeWitnessMap &&typeWitnesses,
                            InheritedConformanceMap &&inheritedConformances,
                            ArrayRef<ValueDecl *> defaultedDefinitions)
    : ProtocolConformance(ProtocolConformanceKind::Normal, conformingType),
      Protocol(protocol),
      ContainingModule(containingModule),
      Mapping(std::move(witnesses)),
      TypeWitnesses(std::move(typeWitnesses)),
      InheritedMapping(std::move(inheritedConformances))
  {
    for (auto def : defaultedDefinitions)
      DefaultedDefinitions.insert(def);
  }

public:
  /// Get the protocol being conformed to.
  ProtocolDecl *getProtocol() const { return Protocol; }

  /// Get the module that contains the conforming extension or type declaration.
  Module *getContainingModule() const { return ContainingModule; }

  /// Override the declaration that provides the conformance.
  void setContainingModule(Module *containing) {
    ContainingModule = containing;
  }

  /// Retrieve the complete set of non-type witnesses.
  const WitnessMap &getWitnesses() const { return Mapping; }

  /// Retrieve the complete set of type witnesses.
  const TypeWitnessMap &getTypeWitnesses() const { return TypeWitnesses; }

  /// Retrieve the protocol conformances directly-inherited protocols.
  const InheritedConformanceMap &getInheritedConformances() const {
    return InheritedMapping;
  }

  /// Determine whether the witness for the given requirement
  /// is either the default definition or was otherwise deduced.
  bool usesDefaultDefinition(ValueDecl *requirement) const {
    return DefaultedDefinitions.count(requirement) > 0;
  }

  /// Retrieve the complete set of defaulted definitions.
  const llvm::SmallPtrSet<ValueDecl *, 4> &getDefaultedDefinitions() const {
    return DefaultedDefinitions;
  }

  static bool classof(const ProtocolConformance *conformance) {
    return conformance->getKind() == ProtocolConformanceKind::Normal;
  }
};

/// Specalized protocol conformance, which projects a generic protocol
/// conformance to one of the specializations of the generic type.
///
/// For example:
/// \code
/// protocol P { func foo() }
/// class A<T> : P { func foo() { } }
/// \endcode
///
/// \c A<T> conforms to \c P via normal protocol conformance. Any specialization
/// of \c A<T> conforms to \c P via a specialized protocol conformance. For
/// example, \c A<Int> conforms to \c P via a specialized protocol conformance
/// that refers to the normal protocol conformance \c A<T> to \c P with the
/// substitution \c T -> \c Int.
class SpecializedProtocolConformance : public ProtocolConformance,
                                       public llvm::FoldingSetNode {
  /// The generic conformance from which this conformance was derived.
  ProtocolConformance *GenericConformance;

  /// The substitutions applied to the generic conformance to produce this
  /// conformance.
  ArrayRef<Substitution> GenericSubstitutions;

  /// The mapping from associated type requirements to their substitutions.
  ///
  /// This is essentially cloned and specialized from the underlying, generic
  /// conformance.
  TypeWitnessMap TypeWitnesses;

  friend class ASTContext;

  SpecializedProtocolConformance(Type conformingType,
                                 ProtocolConformance *genericConformance,
                                 ArrayRef<Substitution> substitutions,
                                 TypeWitnessMap &&typeWitnesses)
    : ProtocolConformance(ProtocolConformanceKind::Specialized,
                          conformingType),
      GenericConformance(genericConformance),
      GenericSubstitutions(substitutions),
      TypeWitnesses(std::move(typeWitnesses))
  {
  }

public:
  /// Get the generic conformance from which this conformance was derived,
  /// if there is one.
  ProtocolConformance *getGenericConformance() const {
    return GenericConformance;
  }

  /// Get the substitutions used to produce this specialized conformance from
  /// the generic conformance.
  ArrayRef<Substitution> getGenericSubstitutions() const {
    return GenericSubstitutions;
  }

  /// Get the protocol being conformed to.
  ProtocolDecl *getProtocol() const {
    return GenericConformance->getProtocol();
  }

  /// Get the module that contains the conforming extension or type declaration.
  Module *getContainingModule() const {
    return GenericConformance->getContainingModule();
  }

  /// Retrieve the complete set of non-type witnesses.
  const WitnessMap &getWitnesses() const {
    return GenericConformance->getWitnesses();
  }

  /// Retrieve the complete set of type witnesses.
  const TypeWitnessMap &getTypeWitnesses() const {
    return TypeWitnesses;
  }

  /// Retrieve the protocol conformances directly-inherited protocols.
  const InheritedConformanceMap &getInheritedConformances() const {
    return GenericConformance->getInheritedConformances();
  }

  /// Determine whether the witness for the given requirement
  /// is either the default definition or was otherwise deduced.
  bool usesDefaultDefinition(ValueDecl *requirement) const {
    return GenericConformance->usesDefaultDefinition(requirement);
  }

  void Profile(llvm::FoldingSetNodeID &ID) {
    Profile(ID, getType(), getGenericConformance());
  }

  static void Profile(llvm::FoldingSetNodeID &ID, Type type,
                      ProtocolConformance *genericConformance) {
    // FIXME: Consider profiling substitutions here. They could differ in
    // some crazy cases that also require major diagnostic work, where the
    // substitutions involve conformances of the same type to the same
    // protocol drawn from different imported modules.
    ID.AddPointer(type.getPointer());
    ID.AddPointer(genericConformance);
  }

  static bool classof(const ProtocolConformance *conformance) {
    return conformance->getKind() == ProtocolConformanceKind::Specialized;
  }
};

/// Inherited protocol conformance, which projects the conformance of a
/// superclass to its subclasses.
///
/// An example:
/// \code
/// protocol P { func foo() }
/// class A : P { func foo() { } }
/// class B : A { }
/// \endcode
///
/// \c A conforms to \c P via normal protocol conformance. The subclass \c B
/// of \c A conforms to \c P via an inherited protocol conformance.
class InheritedProtocolConformance : public ProtocolConformance,
                                     public llvm::FoldingSetNode {
  /// The conformance inherited from the superclass.
  ProtocolConformance *InheritedConformance;

  friend class ASTContext;

  InheritedProtocolConformance(Type conformingType,
                               ProtocolConformance *inheritedConformance)
    : ProtocolConformance(ProtocolConformanceKind::Inherited,
                          conformingType),
      InheritedConformance(inheritedConformance)
  {
  }

public:
  /// Retrieve the conformance for the inherited type.
  ProtocolConformance *getInheritedConformance() const {
    return InheritedConformance;
  }

  /// Get the protocol being conformed to.
  ProtocolDecl *getProtocol() const {
    return InheritedConformance->getProtocol();
  }

  /// Get the module that contains the conforming extension or type declaration.
  Module *getContainingModule() const {
    return InheritedConformance->getContainingModule();
  }

  /// Retrieve the complete set of non-type witnesses.
  const WitnessMap &getWitnesses() const {
    return InheritedConformance->getWitnesses();
  }

  /// Retrieve the complete set of type witnesses.
  const TypeWitnessMap &getTypeWitnesses() const {
    return InheritedConformance->getTypeWitnesses();
  }

  /// Retrieve the protocol conformances directly-inherited protocols.
  const InheritedConformanceMap &getInheritedConformances() const {
    return InheritedConformance->getInheritedConformances();
  }

  /// Determine whether the witness for the given requirement
  /// is either the default definition or was otherwise deduced.
  bool usesDefaultDefinition(ValueDecl *requirement) const {
    return InheritedConformance->usesDefaultDefinition(requirement);
  }

  void Profile(llvm::FoldingSetNodeID &ID) {
    Profile(ID, getType(), getInheritedConformance());
  }

  static void Profile(llvm::FoldingSetNodeID &ID, Type type,
                      ProtocolConformance *inheritedConformance) {
    ID.AddPointer(type.getPointer());
    ID.AddPointer(inheritedConformance);
  }

  static bool classof(const ProtocolConformance *conformance) {
    return conformance->getKind() == ProtocolConformanceKind::Inherited;
  }
};

} // end namespace swift

#endif // LLVM_SWIFT_AST_PROTOCOLCONFORMANCE_H
