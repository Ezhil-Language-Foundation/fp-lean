import Examples.Support

book declaration {{{ Plus }}}
  class Plus (α : Type) where
    plus : α → α → α
stop book declaration


bookExample type {{{ PlusType }}}
  Plus
  ===>
  Type → Type
end bookExample


book declaration {{{ PlusNat }}}
  instance : Plus Nat where
    plus := Nat.add
stop book declaration


expect info {{{ plusNatFiveThree }}}
  #eval Plus.plus 5 3
message
"8
"
end expect


book declaration {{{ openPlus }}}
open Plus (plus)
stop book declaration

expect info {{{ plusNatFiveThreeAgain }}}
  #eval plus 5 3
message
"8
"
end expect

#check plus

bookExample type {{{ plusType }}}
  @Plus.plus
  ===>
  {α : Type} → [Plus α] → α → α → α
end bookExample

expect error {{{ plusFloatFail }}}
  #eval plus 5.2 917.25861
message
"failed to synthesize instance
  Plus Float"
end expect


book declaration {{{ Pos }}}
  inductive Pos : Type where
    | one : Pos
    | succ : Pos → Pos
stop book declaration


expect error {{{ sevenOops }}}
  def seven : Pos := 7
message
"failed to synthesize instance
  OfNat Pos 7"
end expect


book declaration {{{ seven }}}
  def seven : Pos :=
    Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))
stop book declaration


expect error {{{ fourteenOops }}}
  def fourteen : Pos := seven + seven
message
"failed to synthesize instance
  HAdd Pos Pos ?m.285"
end expect

expect error {{{ fortyNineOops }}}
  def fortyNine : Pos := seven * seven
message
"failed to synthesize instance
  HMul Pos Pos ?m.285"
end expect



book declaration {{{ PlusPos }}}
  def Pos.plus : Pos → Pos → Pos
    | Pos.one, k => Pos.succ k
    | Pos.succ n, k => Pos.succ (n.plus k)

  instance : Plus Pos where
    plus := Pos.plus

  def fourteen : Pos := plus seven seven
stop book declaration


book declaration {{{ AddPos }}}
  instance : Add Pos where
    add := Pos.plus
stop book declaration

namespace Extra
book declaration {{{ betterFourteen }}}
  def fourteen : Pos := seven + seven
stop book declaration
end Extra

namespace Foo

axiom x : Nat
axiom y : Nat

evaluation steps {{{ plusDesugar }}}
  x + y
  ===>
  HAdd.hAdd x y
end evaluation steps

end Foo



book declaration {{{ posToNat }}}
def Pos.toNat : Pos → Nat
  | Pos.one => 1
  | Pos.succ n => n.toNat + 1
stop book declaration

namespace Argh

book declaration {{{ posToStringStructure }}}
def posToString (atTop : Bool) (p : Pos) : String :=
  let paren s := if atTop then s else "(" ++ s ++ ")"
  match p with
  | Pos.one => "Pos.one"
  | Pos.succ n => paren s!"Pos.succ {posToString false n}"
stop book declaration

book declaration {{{ UglyToStringPos }}}
instance : ToString Pos where
  toString := posToString true
stop book declaration


expect info {{{ sevenLong }}}
  #eval s!"There are {seven}"
message
"\"There are Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ (Pos.succ Pos.one)))))\"
"
end expect

end Argh

section Blah


book declaration {{{ PosToStringNat }}}
instance : ToString Pos where
  toString x := toString (x.toNat)
stop book declaration

expect info {{{ sevenShort }}}
  #eval s!"There are {seven}"
message
"\"There are 7\"
"
end expect
end Blah

expect info {{{ sevenEvalStr }}}
  #eval seven
message
"7
"
end expect



namespace Foo

evaluation steps {{{ timesDesugar }}}
  x * y
  ===>
  HMul.hMul x y
end evaluation steps

end Foo



book declaration {{{ PosMul }}}
  def Pos.mul : Pos → Pos → Pos
    | Pos.one, k => k
    | Pos.succ n, k => n.mul k + k

  instance : Mul Pos where
    mul := Pos.mul
stop book declaration


expect info {{{ muls }}}
  #eval [seven * Pos.one,
         seven * seven,
         Pos.succ Pos.one * seven]
message
"[7, 49, 14]"
end expect

namespace NatLits


book declaration {{{ OfNat }}}
class OfNat (α : Type) (_ : Nat) where
  ofNat : α
stop book declaration

end NatLits

similar datatypes OfNat NatLits.OfNat


book declaration {{{ LT4 }}}
  inductive LT4 where
    | zero
    | one
    | two
    | three
  deriving Repr
stop book declaration


book declaration {{{ LT4ofNat }}}
  instance : OfNat LT4 0 where
    ofNat := LT4.zero

  instance : OfNat LT4 1 where
    ofNat := LT4.one

  instance : OfNat LT4 2 where
    ofNat := LT4.two

  instance : OfNat LT4 3 where
    ofNat := LT4.three
stop book declaration


expect info {{{ LT4three }}}
  #eval (3 : LT4)
message
  "LT4.three"
end expect

expect info {{{ LT4zero }}}
  #eval (0 : LT4)
message
  "LT4.zero"
end expect

expect error {{{ LT4four }}}
  #eval (4 : LT4)
message
  "failed to synthesize instance
  OfNat LT4 4"
end expect



book declaration {{{ OfNatPos }}}
  instance : OfNat Pos (n + 1) where
    ofNat :=
      let rec natPlusOne : Nat → Pos
        | 0 => Pos.one
        | k + 1 => Pos.succ (natPlusOne k)
      natPlusOne n
stop book declaration


book declaration {{{ eight }}}
  def eight : Pos := 8
stop book declaration


expect error {{{ zeroBad }}}
  def zero : Pos := 0
message
"failed to synthesize instance
  OfNat Pos 0"
end expect

namespace AltPos


book declaration {{{ AltPos }}}
  structure Pos where
    succ ::
    pred : Nat
stop book declaration

end AltPos

bookExample type {{{ printlnType }}}
  @IO.println
  ===>
  {α : Type} → [ToString α] → α → IO Unit
end bookExample


expect info {{{ printlnMetas }}}
  #check IO.println
message
"IO.println : ?m.2497 → IO Unit"
end expect

expect info {{{ printlnNoMetas }}}
  #check @IO.println
message
"@IO.println : {α : Type u_1} → [inst : ToString α] → α → IO Unit"
end expect


book declaration {{{ ListSum }}}
  def List.sum [Add α] [OfNat α 0] : List α → α
    | [] => 0
    | x :: xs => x + xs.sum
stop book declaration


book declaration {{{ fourNats }}}
  def fourNats : List Nat := [1, 2, 3, 4]
stop book declaration


book declaration {{{ fourPos }}}
  def fourPos : List Pos := [1, 2, 3, 4]
stop book declaration


expect info {{{ fourNatsSum }}}
  #eval fourNats.sum
message
"10"
end expect


expect error {{{ fourPosSum }}}
  #eval fourPos.sum
message
"failed to synthesize instance
  OfNat Pos 0"
end expect

namespace PointStuff


book declaration {{{ PPoint }}}
  structure PPoint (α : Type) where
    x : α
    y : α
  deriving Repr
stop book declaration


book declaration {{{ AddPPoint }}}
  instance [Add α] : Add (PPoint α) where
    add p1 p2 := { x := p1.x + p2.x, y := p1.y + p2.y }
stop book declaration

instance [Mul α] : HMul (PPoint α) α (PPoint α) where
  hMul p z := {x := p.x * z, y := p.y * z}

expect info {{{ HMulPPoint }}}
  #eval {x := 2.5, y := 3.7 : PPoint Float} * 2.0
message
 "{ x := 5.000000, y := 7.400000 }"
end expect

end PointStuff



bookExample type {{{ ofNatType }}}
  @OfNat.ofNat
  ===>
  {α : Type} → (n : Nat) → [OfNat α n] → α
end bookExample

bookExample type {{{ addType }}}
  @Add.add
  ===>
  {α : Type} → [Add α] → α → α → α
end bookExample


namespace Foo

evaluation steps {{{ minusDesugar }}}
  x - y
  ===>
  Sub.sub x y
end evaluation steps

evaluation steps {{{ divDesugar }}}
  x / y
  ===>
  Div.div x y
end evaluation steps

evaluation steps {{{ modDesugar }}}
  x % y
  ===>
  Mod.mod x y
end evaluation steps

evaluation steps {{{ powDesugar }}}
  x ^ y
  ===>
  Pow.pow x y
end evaluation steps

end Foo

namespace OverloadedInt

axiom x : Int

evaluation steps {{{ negDesugar }}}
  (- x)
  ===>
  Neg.neg x
end evaluation steps

end OverloadedInt

namespace OverloadedBits

axiom x : UInt8
axiom y : UInt8

evaluation steps {{{ bAndDesugar }}}
  x &&& y
  ===>
  AndOp.and x y
end evaluation steps

evaluation steps {{{ bOrDesugar }}}
  x ||| y
  ===>
  OrOp.or x y
end evaluation steps

evaluation steps {{{ bXorDesugar }}}
  x ^^^ y
  ===>
  Xor.xor x y
end evaluation steps

evaluation steps {{{ complementDesugar }}}
  ~~~ x
  ===>
  Complement.complement x
end evaluation steps

evaluation steps {{{ shrDesugar }}}
  x >>> y
  ===>
  ShiftRight.shiftRight x y
end evaluation steps

evaluation steps {{{ shlDesugar }}}
  x <<< y
  ===>
  ShiftLeft.shiftLeft x y
end evaluation steps

evaluation steps {{{ beqDesugar }}}
  x == y
  ===>
  BEq.beq x y
end evaluation steps



end OverloadedBits


book declaration {{{ addNatPos }}}
  def addNatPos : Nat → Pos → Pos
    | 0, p => p
    | n + 1, p => Pos.succ (addNatPos n p)

  def addPosNat : Pos → Nat → Pos
    | p, 0 => p
    | p, n + 1 => Pos.succ (addPosNat p n)
stop book declaration



book declaration {{{ haddInsts }}}
  instance : HAdd Nat Pos Pos where
    hAdd := addNatPos

  instance : HAdd Pos Nat Pos where
    hAdd := addPosNat
stop book declaration


expect info {{{ posNatEx }}}
  #eval (3 : Pos) + (5 : Nat)
message
  "8"
end expect

expect info {{{ natPosEx }}}
  #eval (3 : Nat) + (5 : Pos)
message
  "8"
end expect

namespace ProblematicHPlus

book declaration {{{ HPlus }}}
  class HPlus (α : Type) (β : Type) (γ : Type) where
    hPlus : α → β → γ
stop book declaration


book declaration {{{ HPlusInstances }}}
  instance : HPlus Nat Pos Pos where
    hPlus := addNatPos

  instance : HPlus Pos Nat Pos where
    hPlus := addPosNat
stop book declaration

expect error {{{ hPlusOops }}}
  #eval HPlus.hPlus (3 : Pos) (5 : Nat)
message
"typeclass instance problem is stuck, it is often due to metavariables
  HPlus Pos Nat ?m.5048"
end expect


expect info {{{ hPlusLotsaTypes }}}
  #eval (HPlus.hPlus (3 : Pos) (5 : Nat) : Pos)
message
  "8"
end expect

end ProblematicHPlus



namespace BetterHPlus

book declaration {{{ HPlusOut }}}
  class HPlus (α : Type) (β : Type) (γ : outParam Type) where
    hPlus : α → β → γ
stop book declaration

instance : HPlus Nat Pos Pos where
  hPlus := addNatPos

instance : HPlus Pos Nat Pos where
  hPlus := addPosNat

expect info {{{ hPlusWorks }}}
  #eval HPlus.hPlus (3 : Pos) (5 : Nat)
message
  "8"
end expect


book declaration {{{ notDefaultAdd }}}
  instance [Add α] : HPlus α α α where
    hPlus := Add.add
stop book declaration

expect info {{{ plusFiveThree }}}
  #check HPlus.hPlus (5 : Nat) (3 : Nat)
message
  "HPlus.hPlus 5 3 : Nat"
end expect

expect info {{{ plusFiveMeta }}}
  #check HPlus.hPlus (5 : Nat)
message
  "HPlus.hPlus 5 : ?m.5136 → ?m.5138"
end expect


book declaration {{{ defaultAdd }}}
  @[defaultInstance]
  instance [Add α] : HPlus α α α where
    hPlus := Add.add
stop book declaration


expect info {{{ plusFive }}}
  #check HPlus.hPlus (5 : Nat)
message
  "HPlus.hPlus 5 : Nat → Nat"
end expect

end BetterHPlus

similar datatypes ProblematicHPlus.HPlus BetterHPlus.HPlus

bookExample type {{{ fiveType }}}
  5
  ===>
  Nat
end bookExample


-- Example for exercise
inductive Method where
  | GET
  | POST
  | PUT
  | DELETE

structure Response where

class HTTP (m : Method) where
  doTheWork : (uri : String) → IO Response
