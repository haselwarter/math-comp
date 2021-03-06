(* (c) Copyright 2006-2016 Microsoft Corporation and Inria.                  *)
(* Distributed under the terms of CeCILL-B.                                  *)
From mathcomp Require Import ssreflect ssrfun ssrbool eqtype ssrnat seq choice.
From mathcomp Require Import fintype bigop ssralg.
From mathcomp Require Import generic_quotient ring_quotient.

(*****************************************************************************)
(* This file clones part of ssralg hierachy for countable types; it does not *)
(* cover the left module / algebra interfaces, providing only                *)
(*          countZmodType == countable zmodType interface.                   *)
(*          countRingType == countable ringType interface.                   *)
(*       countComRingType == countable comRingType interface.                *)
(*      countUnitRingType == countable unitRingType interface.               *)
(*   countComUnitRingType == countable comUnitRingType interface.            *)
(*       countIdomainType == countable idomainType interface.                *)
(*         countFieldType == countable fieldType interface.                  *)
(*      countDecFieldType == countable decFieldType interface.               *)
(*   countClosedFieldType == countable closedFieldType interface.            *)
(* The interface cloning syntax is extended to these structures              *)
(*   [countZmodType of M] == countZmodType structure for an M that has both  *)
(*                           zmodType and countType structures.              *)
(*                    ... etc                                                *)
(* This file provides constructions for both simple extension and algebraic  *)
(* closure of countable fields.                                              *)
(*****************************************************************************)

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Local Open Scope ring_scope.
Import GRing.Theory CodeSeq.

Module CountRing.

Local Notation mixin_of T := (Countable.mixin_of T).

Section Generic.

(* Implicits *)
Variables (type base_type : Type) (class_of base_of : Type -> Type).
Variable base_sort : base_type -> Type.

(* Explicits *)
Variable Pack : forall T, class_of T -> type.
Variable Class : forall T, base_of T -> mixin_of T -> class_of T.
Variable base_class : forall bT, base_of (base_sort bT).

Definition gen_pack T :=
  fun bT b & phant_id (base_class bT) b =>
  fun fT c m & phant_id (Countable.class fT) (Countable.Class c m) =>
  Pack (@Class T b m).

End Generic.

Arguments gen_pack [type base_type class_of base_of base_sort].
Local Notation cnt_ c := (@Countable.Class _ c c).
Local Notation do_pack pack T := (pack T _ _ id _ _ _ id).
Import GRing.Theory.

Module Zmodule.

Section ClassDef.

Set Primitive Projections.
Record class_of M :=
  Class { base : GRing.Zmodule.class_of M; mixin : mixin_of M }.
Unset Primitive Projections.
Local Coercion base : class_of >-> GRing.Zmodule.class_of.
Local Coercion mixin : class_of >-> mixin_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.Zmodule.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.

Definition join_countType := @Countable.Pack zmodType (cnt_ class).

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.Zmodule.class_of.
Coercion mixin : class_of >-> mixin_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Canonical join_countType.
Notation countZmodType := type.
Notation "[ 'countZmodType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countZmodType'  'of'  T ]") : form_scope.
End Exports.

End Zmodule.
Import Zmodule.Exports.

Module Ring.

Section ClassDef.

Set Primitive Projections.
Record class_of R := Class { base : GRing.Ring.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := Zmodule.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.Ring.class_of.
Local Coercion base2 : class_of >-> Zmodule.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.Ring.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition join_countType := @Countable.Pack ringType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack ringType class.

End ClassDef.

Module Import Exports.
Coercion base : class_of >-> GRing.Ring.class_of.
Coercion base2 : class_of >-> Zmodule.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Canonical join_countType.
Canonical join_countZmodType.
Notation countRingType := type.
Notation "[ 'countRingType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countRingType'  'of'  T ]") : form_scope.
End Exports.

End Ring.
Import Ring.Exports.

Module ComRing.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.ComRing.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := Ring.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.ComRing.class_of.
Local Coercion base2 : class_of >-> Ring.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.ComRing.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition join_countType := @Countable.Pack comRingType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack comRingType class.
Definition join_countRingType := @Ring.Pack comRingType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.ComRing.class_of.
Coercion base2 : class_of >-> Ring.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Notation countComRingType := CountRing.ComRing.type.
Notation "[ 'countComRingType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countComRingType'  'of'  T ]") : form_scope.
End Exports.

End ComRing.
Import ComRing.Exports.

Module UnitRing.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.UnitRing.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := Ring.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.UnitRing.class_of.
Local Coercion base2 : class_of >-> Ring.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.UnitRing.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.

Definition join_countType := @Countable.Pack unitRingType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack unitRingType class.
Definition join_countRingType := @Ring.Pack unitRingType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.UnitRing.class_of.
Coercion base2 : class_of >-> Ring.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Notation countUnitRingType := CountRing.UnitRing.type.
Notation "[ 'countUnitRingType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countUnitRingType'  'of'  T ]") : form_scope.
End Exports.

End UnitRing.
Import UnitRing.Exports.

Module ComUnitRing.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.ComUnitRing.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := ComRing.Class (base c) (mixin c).
Definition base3 R (c : class_of R) := @UnitRing.Class R (base c) (mixin c).
Local Coercion base : class_of >-> GRing.ComUnitRing.class_of.
Local Coercion base2 : class_of >-> ComRing.class_of.
Local Coercion base3 : class_of >-> UnitRing.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.ComUnitRing.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition countComRingType := @ComRing.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.
Definition countUnitRingType := @UnitRing.Pack cT class.
Definition comUnitRingType := @GRing.ComUnitRing.Pack cT class.

Definition join_countType := @Countable.Pack comUnitRingType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack comUnitRingType class.
Definition join_countRingType := @Ring.Pack comUnitRingType class.
Definition join_countComRingType := @ComRing.Pack comUnitRingType class.
Definition join_countUnitRingType := @UnitRing.Pack comUnitRingType class.
Definition ujoin_countComRingType := @ComRing.Pack unitRingType class.
Definition cjoin_countUnitRingType := @UnitRing.Pack comRingType class.
Definition ccjoin_countUnitRingType := @UnitRing.Pack countComRingType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.ComUnitRing.class_of.
Coercion base2 : class_of >-> ComRing.class_of.
Coercion base3 : class_of >-> UnitRing.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Coercion countComRingType : type >-> ComRing.type.
Canonical countComRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Coercion countUnitRingType : type >-> UnitRing.type.
Canonical countUnitRingType.
Coercion comUnitRingType : type >-> GRing.ComUnitRing.type.
Canonical comUnitRingType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Canonical join_countComRingType.
Canonical join_countUnitRingType.
Canonical ujoin_countComRingType.
Canonical cjoin_countUnitRingType.
Canonical ccjoin_countUnitRingType.
Notation countComUnitRingType := CountRing.ComUnitRing.type.
Notation "[ 'countComUnitRingType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countComUnitRingType'  'of'  T ]") : form_scope.
End Exports.

End ComUnitRing.
Import ComUnitRing.Exports.

Module IntegralDomain.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.IntegralDomain.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := ComUnitRing.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.IntegralDomain.class_of.
Local Coercion base2 : class_of >-> ComUnitRing.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.IntegralDomain.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition countComRingType := @ComRing.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.
Definition countUnitRingType := @UnitRing.Pack cT class.
Definition comUnitRingType := @GRing.ComUnitRing.Pack cT class.
Definition countComUnitRingType := @ComUnitRing.Pack cT class.
Definition idomainType := @GRing.IntegralDomain.Pack cT class.

Definition join_countType := @Countable.Pack idomainType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack idomainType class.
Definition join_countRingType := @Ring.Pack idomainType class.
Definition join_countUnitRingType := @UnitRing.Pack idomainType class.
Definition join_countComRingType := @ComRing.Pack idomainType class.
Definition join_countComUnitRingType := @ComUnitRing.Pack idomainType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.IntegralDomain.class_of.
Coercion base2 : class_of >-> ComUnitRing.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Coercion countComRingType : type >-> ComRing.type.
Canonical countComRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Coercion countUnitRingType : type >-> UnitRing.type.
Canonical countUnitRingType.
Coercion comUnitRingType : type >-> GRing.ComUnitRing.type.
Canonical comUnitRingType.
Coercion countComUnitRingType : type >-> ComUnitRing.type.
Canonical countComUnitRingType.
Coercion idomainType : type >-> GRing.IntegralDomain.type.
Canonical idomainType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Canonical join_countComRingType.
Canonical join_countUnitRingType.
Canonical join_countComUnitRingType.
Notation countIdomainType := CountRing.IntegralDomain.type.
Notation "[ 'countIdomainType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countIdomainType'  'of'  T ]") : form_scope.
End Exports.

End IntegralDomain.
Import IntegralDomain.Exports.

Module Field.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.Field.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := IntegralDomain.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.Field.class_of.
Local Coercion base2 : class_of >-> IntegralDomain.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.Field.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition countComRingType := @ComRing.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.
Definition countUnitRingType := @UnitRing.Pack cT class.
Definition comUnitRingType := @GRing.ComUnitRing.Pack cT class.
Definition countComUnitRingType := @ComUnitRing.Pack cT class.
Definition idomainType := @GRing.IntegralDomain.Pack cT class.
Definition countIdomainType := @IntegralDomain.Pack cT class.
Definition fieldType := @GRing.Field.Pack cT class.

Definition join_countType := @Countable.Pack fieldType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack fieldType class.
Definition join_countRingType := @Ring.Pack fieldType class.
Definition join_countUnitRingType := @UnitRing.Pack fieldType class.
Definition join_countComRingType := @ComRing.Pack fieldType class.
Definition join_countComUnitRingType := @ComUnitRing.Pack fieldType class.
Definition join_countIdomainType := @IntegralDomain.Pack fieldType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.Field.class_of.
Coercion base2 : class_of >-> IntegralDomain.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Coercion countComRingType : type >-> ComRing.type.
Canonical countComRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Coercion countUnitRingType : type >-> UnitRing.type.
Canonical countUnitRingType.
Coercion comUnitRingType : type >-> GRing.ComUnitRing.type.
Canonical comUnitRingType.
Coercion countComUnitRingType : type >-> ComUnitRing.type.
Canonical countComUnitRingType.
Coercion idomainType : type >-> GRing.IntegralDomain.type.
Canonical idomainType.
Coercion countIdomainType : type >-> IntegralDomain.type.
Canonical countIdomainType.
Coercion fieldType : type >-> GRing.Field.type.
Canonical fieldType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Canonical join_countComRingType.
Canonical join_countUnitRingType.
Canonical join_countComUnitRingType.
Canonical join_countIdomainType.
Notation countFieldType := CountRing.Field.type.
Notation "[ 'countFieldType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countFieldType'  'of'  T ]") : form_scope.
End Exports.

End Field.
Import Field.Exports.

Module DecidableField.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.DecidableField.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := Field.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.DecidableField.class_of.
Local Coercion base2 : class_of >-> Field.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.DecidableField.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition countComRingType := @ComRing.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.
Definition countUnitRingType := @UnitRing.Pack cT class.
Definition comUnitRingType := @GRing.ComUnitRing.Pack cT class.
Definition countComUnitRingType := @ComUnitRing.Pack cT class.
Definition idomainType := @GRing.IntegralDomain.Pack cT class.
Definition countIdomainType := @IntegralDomain.Pack cT class.
Definition fieldType := @GRing.Field.Pack cT class.
Definition countFieldType := @Field.Pack cT class.
Definition decFieldType := @GRing.DecidableField.Pack cT class.

Definition join_countType := @Countable.Pack decFieldType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack decFieldType class.
Definition join_countRingType := @Ring.Pack decFieldType class.
Definition join_countUnitRingType := @UnitRing.Pack decFieldType class.
Definition join_countComRingType := @ComRing.Pack decFieldType class.
Definition join_countComUnitRingType := @ComUnitRing.Pack decFieldType class.
Definition join_countIdomainType := @IntegralDomain.Pack decFieldType class.
Definition join_countFieldType := @Field.Pack decFieldType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.DecidableField.class_of.
Coercion base2 : class_of >-> Field.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Coercion countComRingType : type >-> ComRing.type.
Canonical countComRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Coercion countUnitRingType : type >-> UnitRing.type.
Canonical countUnitRingType.
Coercion comUnitRingType : type >-> GRing.ComUnitRing.type.
Canonical comUnitRingType.
Coercion countComUnitRingType : type >-> ComUnitRing.type.
Canonical countComUnitRingType.
Coercion idomainType : type >-> GRing.IntegralDomain.type.
Canonical idomainType.
Coercion countIdomainType : type >-> IntegralDomain.type.
Canonical countIdomainType.
Coercion fieldType : type >-> GRing.Field.type.
Canonical fieldType.
Coercion countFieldType : type >-> Field.type.
Canonical countFieldType.
Coercion decFieldType : type >-> GRing.DecidableField.type.
Canonical decFieldType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Canonical join_countComRingType.
Canonical join_countUnitRingType.
Canonical join_countComUnitRingType.
Canonical join_countIdomainType.
Canonical join_countFieldType.
Notation countDecFieldType := CountRing.DecidableField.type.
Notation "[ 'countDecFieldType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countDecFieldType'  'of'  T ]") : form_scope.
End Exports.

End DecidableField.
Import DecidableField.Exports.

Module ClosedField.

Section ClassDef.

Set Primitive Projections.
Record class_of R :=
  Class { base : GRing.ClosedField.class_of R; mixin : mixin_of R }.
Unset Primitive Projections.
Definition base2 R (c : class_of R) := DecidableField.Class (base c) (mixin c).
Local Coercion base : class_of >-> GRing.ClosedField.class_of.
Local Coercion base2 : class_of >-> DecidableField.class_of.

Structure type := Pack {sort; _ : class_of sort}.
Local Coercion sort : type >-> Sortclass.
Definition pack := gen_pack Pack Class GRing.ClosedField.class.
Variable cT : type.
Definition class := let: Pack _ c as cT' := cT return class_of cT' in c.

Definition eqType := @Equality.Pack cT class.
Definition choiceType := @Choice.Pack cT class.
Definition countType := @Countable.Pack cT (cnt_ class).
Definition zmodType := @GRing.Zmodule.Pack cT class.
Definition countZmodType := @Zmodule.Pack cT class.
Definition ringType := @GRing.Ring.Pack cT class.
Definition countRingType := @Ring.Pack cT class.
Definition comRingType := @GRing.ComRing.Pack cT class.
Definition countComRingType := @ComRing.Pack cT class.
Definition unitRingType := @GRing.UnitRing.Pack cT class.
Definition countUnitRingType := @UnitRing.Pack cT class.
Definition comUnitRingType := @GRing.ComUnitRing.Pack cT class.
Definition countComUnitRingType := @ComUnitRing.Pack cT class.
Definition idomainType := @GRing.IntegralDomain.Pack cT class.
Definition countIdomainType := @IntegralDomain.Pack cT class.
Definition fieldType := @GRing.Field.Pack cT class.
Definition countFieldType := @Field.Pack cT class.
Definition decFieldType := @GRing.DecidableField.Pack cT class.
Definition countDecFieldType := @DecidableField.Pack cT class.
Definition closedFieldType := @GRing.ClosedField.Pack cT class.

Definition join_countType := @Countable.Pack closedFieldType (cnt_ class).
Definition join_countZmodType := @Zmodule.Pack closedFieldType class.
Definition join_countRingType := @Ring.Pack closedFieldType class.
Definition join_countUnitRingType := @UnitRing.Pack closedFieldType class.
Definition join_countComRingType := @ComRing.Pack closedFieldType class.
Definition join_countComUnitRingType := @ComUnitRing.Pack closedFieldType class.
Definition join_countIdomainType := @IntegralDomain.Pack closedFieldType class.
Definition join_countFieldType := @Field.Pack closedFieldType class.
Definition join_countDecFieldType := @DecidableField.Pack closedFieldType class.

End ClassDef.

Module Exports.
Coercion base : class_of >-> GRing.ClosedField.class_of.
Coercion base2 : class_of >-> DecidableField.class_of.
Coercion sort : type >-> Sortclass.
Bind Scope ring_scope with sort.
Coercion eqType : type >-> Equality.type.
Canonical eqType.
Coercion choiceType : type >-> Choice.type.
Canonical choiceType.
Coercion countType : type >-> Countable.type.
Canonical countType.
Coercion zmodType : type >-> GRing.Zmodule.type.
Canonical zmodType.
Coercion countZmodType : type >-> Zmodule.type.
Canonical countZmodType.
Coercion ringType : type >-> GRing.Ring.type.
Canonical ringType.
Coercion countRingType : type >-> Ring.type.
Canonical countRingType.
Coercion comRingType : type >-> GRing.ComRing.type.
Canonical comRingType.
Coercion countComRingType : type >-> ComRing.type.
Canonical countComRingType.
Coercion unitRingType : type >-> GRing.UnitRing.type.
Canonical unitRingType.
Coercion countUnitRingType : type >-> UnitRing.type.
Canonical countUnitRingType.
Coercion comUnitRingType : type >-> GRing.ComUnitRing.type.
Canonical comUnitRingType.
Coercion countComUnitRingType : type >-> ComUnitRing.type.
Canonical countComUnitRingType.
Coercion idomainType : type >-> GRing.IntegralDomain.type.
Canonical idomainType.
Coercion countIdomainType : type >-> IntegralDomain.type.
Canonical countIdomainType.
Coercion fieldType : type >-> GRing.Field.type.
Canonical fieldType.
Coercion countFieldType : type >-> Field.type.
Canonical countFieldType.
Coercion decFieldType : type >-> GRing.DecidableField.type.
Canonical decFieldType.
Coercion countDecFieldType : type >-> DecidableField.type.
Canonical countDecFieldType.
Coercion closedFieldType : type >-> GRing.ClosedField.type.
Canonical closedFieldType.
Canonical join_countType.
Canonical join_countZmodType.
Canonical join_countRingType.
Canonical join_countComRingType.
Canonical join_countUnitRingType.
Canonical join_countComUnitRingType.
Canonical join_countIdomainType.
Canonical join_countFieldType.
Canonical join_countDecFieldType.
Notation countClosedFieldType := CountRing.ClosedField.type.
Notation "[ 'countClosedFieldType' 'of' T ]" := (do_pack pack T)
  (at level 0, format "[ 'countClosedFieldType'  'of'  T ]") : form_scope.
End Exports.

End ClosedField.
Import ClosedField.Exports.

End CountRing.

Import CountRing.
Export Zmodule.Exports Ring.Exports ComRing.Exports UnitRing.Exports.
Export ComUnitRing.Exports IntegralDomain.Exports.
Export Field.Exports DecidableField.Exports ClosedField.Exports.
