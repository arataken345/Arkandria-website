EXTERNAL MENTAL_UP(n)
EXTERNAL MENTAL_DOWN(n)
EXTERNAL TIER_UP(stat)
EXTERNAL TIER_DOWN(stat)
EXTERNAL ENERGY_UP(n)
EXTERNAL ENERGY_DOWN(n)
EXTERNAL ADD_EMOTION(name, amt)
EXTERNAL ADD_TEMP(name, nodes)
EXTERNAL SET_STATUS(s)
EXTERNAL SET_BODY(text)
EXTERNAL GRANT_ITEM(id)
EXTERNAL ADD_FAVOR(npc, amt)
EXTERNAL UNLOCK_ACHV(id)
EXTERNAL TUT_POP(id)
EXTERNAL CHECKPOINT(name)
EXTERNAL DEATH()
EXTERNAL FAINT_CHECK()

VAR wounded = false
VAR pintu_dibuka = false

-> prolog

=== prolog ===
#KICKER:Prologue — Awakening
#TAG:Observation Room 3
#AUDIO:reception
~ TUT_POP("awal")
~ CHECKPOINT("awal")
~ ADD_EMOTION("Takut", 1)
~ MENTAL_UP(1)
~ GRANT_ITEM("cokelat")
~ ADD_TEMP("Ketakutan", 3)
~ SET_STATUS("danger")
~ ADD_FAVOR("Dokter Hantu", 1)
You wake on a cold floor. The smell of carbolic acid and iron fills your nose.
The corridor light flickers — off, on, off — like something breathing.
In your pocket: a chocolate bar. Small. But real.
* [Stand and check the corridor]
    ~ MENTAL_DOWN(1)
    -> lorong
* [Sit a moment. Steady your breath.]
    ~ ADD_EMOTION("Lega", 1)
    -> lorong

=== lorong ===
#KICKER:Part One — The Corridor
#TAG:West Corridor
#AUDIO:corridor
#IMAGE:bg_corridor
~ TIER_UP("Stress")
~ ENERGY_DOWN(10)
Shadows stretch across peeling walls. Something drips in the distance — slow, rhythmic.
You feel watched.
* [Follow the dripping sound] -> tetesan
* [Hide behind the nearest door]
    ~ UNLOCK_ACHV("smart_cross")
    -> ruang_aman

=== ruang_aman ===
#TAG:Archive Room
#STATUS:safe
~ SET_STATUS("safe")
~ TIER_DOWN("Stress")
~ ADD_EMOTION("Lega", 1)
You slip into the archive room and hold your breath. Footsteps pass the door — then fade.
For the first time tonight, silence feels safe.
* [Keep moving down the corridor] -> tetesan

=== tetesan ===
#TAG:End of the Corridor
#AUDIO:darkstare
~ SET_STATUS("wounded")
~ SET_BODY("Sprained ankle")
~ GRANT_ITEM("perban_kotor")
~ MENTAL_UP(1)
A rusted pipe bursts just as you pass. Shrapnel slams into your ankle.
Blood seeps. Every step now feels wrong.
* {not wounded} [Run as fast as you can] -> lolos
* [Limp toward the light at the end]
    ~ ENERGY_DOWN(25)
    -> pintu_baja
* [Touch the black stain on the wall] -> kematian

=== lolos ===
#TAG:Outside the Building?
This path should not exist — but your legs feel light, and the air here does not smell of carbolic.
Maybe you got out. Maybe not.
-> END

=== pintu_baja ===
#KICKER:Part Two — The Steel Door
#TAG:The Steel Door
#AUDIO:corridor
~ CHECKPOINT("pintu_baja")
~ TUT_POP("energi")
The steel door hangs rusted on its hinges. Behind it hums an old machine.
Your body feels heavy. Choose sparingly.
* [Push the door]
    ~ ENERGY_DOWN(30)
    -> akhir
* [Rest a moment first]
    ~ ENERGY_UP(25)
    ~ TIER_DOWN("Kelelahan")
    -> akhir
* {not pintu_dibuka} [Pry the lock with a coin]
    ~ pintu_dibuka = true
    ~ GRANT_ITEM("koin_logam")
    -> akhir

=== kematian ===
#TAG:Darkness
#AUDIO:death
The black stain is warm. Then cold. Then — nothing at all.
The darkness does not ask. It only takes.
~ UNLOCK_ACHV("trap_victim")
~ DEATH()
-> END

=== akhir ===
#KICKER:Sample Epilogue
#TAG:Threshold
#AUDIO:reception
~ SET_STATUS("safe")
~ UNLOCK_ACHV("explorer")
~ ADD_EMOTION("Lega", 2)
~ MENTAL_DOWN(2)
The door opens with a long groan. Light — real light — greets you.
You survived. For this sample, that is enough.
-> END
