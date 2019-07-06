//===--- ProtocolConformanceRef.h - AST Protocol Conformance ----*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// This file defines the ProtocolConformanceRef type.
//
//===----------------------------------------------------------------------===//
#ifndef SWIFT_AST_PROTOCOLCONFORMANCEREF_H
#define SWIFT_AST_PROTOCOLCONFORMANCEREF_H

#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/PointerUnion.h"
#include "swift/AST/Requirement.h"
#include "swift/AST/TypeAlignments.h"
#include "swift/AST/Type.h"

namespace llvm {
  class raw_ostream;
}

namespace swift {

class ConcreteDeclRef;
class ProtocolConformance;

/// A ProtocolConformanceRef is a handle to a protocol conformance which
/// may be either concrete or abstract.
///
/// A concrete conformance is derived from a specific protocol conformance
/// declaration.
///
/// An abstract conformance is derived from context: the conforming type
/// is either existential or opaque (i.e. an archetype), and while the
/// type-checker promises that the conformance exists, it is not known
/// statically which concrete conformance it refers to.
///
/// ProtocolConformanceRef allows the efficient recovery of the protocol
/// even when the conformance is abstract.
class ProtocolConformanceRef {
  using UnionType = llvm::PointerUnion<ProtocolDecl*, ProtocolConformance*>;
  UnionType Union;

  explicit ProtocolConformanceRef(UnionType value) : Union(value) {}

public:
  /// Create an abstract protocol conformance reference.
  explicit ProtocolConformanceRef(ProtocolDecl *proto) : Union(proto) {
    assert(proto != nullptr &&
           "cannot construct ProtocolConformanceRef with null");
  }

  /// Create a concrete protocol conformance reference.
  explicit ProtocolConformanceRef(ProtocolConformance *conf) : Union(conf) {
    assert(conf != nullptr &&
           "cannot construct ProtocolConformanceRef with null");
  }

  static ProtocolConformanceRef forInvalid() {
    return ProtocolConformanceRef(UnionType((ProtocolDecl *)nullptr));
  }

  bool isInvalid() const {
    return !Union;
  }

  /// Create either a concrete or an abstract protocol conformance reference,
  /// depending on whether ProtocolConformance is null.
  explicit ProtocolConformanceRef(ProtocolDecl *protocol,
                                  ProtocolConformance *conf);

  bool isConcrete() const {
    return !isInvalid() && Union.is<ProtocolConformance*>();
  }
  ProtocolConformance *getConcrete() const {
    return Union.get<ProtocolConformance*>();
  }

  bool isAbstract() const {
    return !isInvalid() && Union.is<ProtocolDecl*>();
  }

  ProtocolDecl *getAbstract() const {
    return Union.get<ProtocolDecl*>();
  }

  using OpaqueValue = void*;
  OpaqueValue getOpaqueValue() const { return Union.getOpaqueValue(); }
  static ProtocolConformanceRef getFromOpaqueValue(OpaqueValue value) {
    return ProtocolConformanceRef(UnionType::getFromOpaqueValue(value));
  }

  /// Return the protocol requirement.
  ProtocolDecl *getRequirement() const;
  
  /// Apply a substitution to the conforming type.
  ProtocolConformanceRef subst(Type origType,
                               SubstitutionMap subMap) const;

  /// Apply a substitution to the conforming type.
  ProtocolConformanceRef subst(Type origType,
                               TypeSubstitutionFn subs,
                               LookupConformanceFn conformances,
                               SubstOptions options = None) const;

  /// Map contextual types to interface types in the conformance.
  ProtocolConformanceRef mapConformanceOutOfContext() const;

  /// Given a dependent type (expressed in terms of this conformance's
  /// protocol), follow it from the conforming type.
  Type getAssociatedType(Type origType, Type dependentType,
                         LazyResolver *resolver = nullptr) const;

  /// Given a dependent type (expressed in terms of this conformance's
  /// protocol) and conformance, follow it from the conforming type.
  ProtocolConformanceRef
  getAssociatedConformance(Type origType, Type dependentType,
                           ProtocolDecl *requirement,
                           LazyResolver *resolver = nullptr) const;

  void dump() const;
  void dump(llvm::raw_ostream &out, unsigned indent = 0) const;

  bool operator==(ProtocolConformanceRef other) const {
    return Union == other.Union;
  }
  bool operator!=(ProtocolConformanceRef other) const {
    return Union != other.Union;
  }

  friend llvm::hash_code hash_value(ProtocolConformanceRef conformance) {
    return llvm::hash_value(conformance.Union.getOpaqueValue());
  }

  Type getTypeWitnessByName(Type type, Identifier name) const;

  /// Find a particular named function witness for a type that conforms to
  /// the given protocol.
  ///
  /// \param type The conforming type.
  ///
  /// \param name The name of the requirement.
  ConcreteDeclRef getWitnessByName(Type type, DeclName name) const;

  /// Determine whether this conformance is canonical.
  bool isCanonical() const;

  /// Create a canonical conformance from the current one.
  ProtocolConformanceRef getCanonicalConformanceRef() const;

  /// Get any additional requirements that are required for this conformance to
  /// be satisfied, if they're possible to compute.
  Optional<ArrayRef<Requirement>> getConditionalRequirementsIfAvailable() const;

  /// Get any additional requirements that are required for this conformance to
  /// be satisfied.
  ArrayRef<Requirement> getConditionalRequirements() const;
};

} // end namespace swift

#endif // LLVM_SWIFT_AST_PROTOCOLCONFORMANCEREF_H
