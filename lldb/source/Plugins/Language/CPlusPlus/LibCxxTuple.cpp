//===-- LibCxxTuple.cpp -----------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "LibCxx.h"
#include "lldb/DataFormatters/FormattersHelpers.h"

using namespace lldb;
using namespace lldb_private;

namespace {

class TupleFrontEnd: public SyntheticChildrenFrontEnd {
public:
  TupleFrontEnd(ValueObject &valobj) : SyntheticChildrenFrontEnd(valobj) {
    Update();
  }

  size_t GetIndexOfChildWithName(ConstString name) override {
    return formatters::ExtractIndexFromString(name.GetCString());
  }

  bool MightHaveChildren() override { return true; }
  bool Update() override;
  size_t CalculateNumChildren() override { return m_elements.size(); }
  ValueObjectSP GetChildAtIndex(size_t idx) override;

private:
  // The lifetime of a ValueObject and all its derivative ValueObjects
  // (children, clones, etc.) is managed by a ClusterManager. These
  // objects are only destroyed when every shared pointer to any of them
  // is destroyed, so we must not store a shared pointer to any ValueObject
  // derived from our backend ValueObject (since we're in the same cluster).
  std::vector<ValueObject*> m_elements;
  ValueObject* m_base = nullptr;
};
}

bool TupleFrontEnd::Update() {
  m_elements.clear();
  m_base = nullptr;

  ValueObjectSP base_sp;
  base_sp = m_backend.GetChildMemberWithName(ConstString("__base_"), true);
  if (!base_sp) {
    // Pre r304382 name of the base element.
    base_sp = m_backend.GetChildMemberWithName(ConstString("base_"), true);
  }
  if (!base_sp)
    return false;
  m_base = base_sp.get();
  m_elements.assign(base_sp->GetCompilerType().GetNumDirectBaseClasses(),
                    nullptr);
  return false;
}

ValueObjectSP TupleFrontEnd::GetChildAtIndex(size_t idx) {
  if (idx >= m_elements.size())
    return ValueObjectSP();
  if (!m_base)
    return ValueObjectSP();
  if (m_elements[idx])
    return m_elements[idx]->GetSP();

  CompilerType holder_type =
      m_base->GetCompilerType().GetDirectBaseClassAtIndex(idx, nullptr);
  if (!holder_type)
    return ValueObjectSP();
  ValueObjectSP holder_sp = m_base->GetChildAtIndex(idx, true);
  if (!holder_sp)
    return ValueObjectSP();

  ValueObjectSP elem_sp = holder_sp->GetChildAtIndex(0, true);
  if (elem_sp)
    m_elements[idx] =
        elem_sp->Clone(ConstString(llvm::formatv("[{0}]", idx).str())).get();

  return m_elements[idx]->GetSP();
}

SyntheticChildrenFrontEnd *
formatters::LibcxxTupleFrontEndCreator(CXXSyntheticChildren *,
                                       lldb::ValueObjectSP valobj_sp) {
  if (valobj_sp)
    return new TupleFrontEnd(*valobj_sp);
  return nullptr;
}
