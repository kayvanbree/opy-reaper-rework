@Rule "Disable wraith"
@Event eachPlayer
@Hero reaper
eventPlayer.setAbility1Enabled(false)


@Rule "Disable shadow step"
@Event eachPlayer
@Hero reaper
eventPlayer.setAbility2Enabled(false)


@Rule "Remove life-steal"
@Event playerDealtDamage
@Hero reaper
if eventPlayer.getHealth() != eventPlayer.getMaxHealth() and eventPlayer.I != eventPlayer:
    damage(eventPlayer, eventPlayer, eventDamage * 0.3)
    eventPlayer.I = null
    eventPlayer.J = null


@Rule "Prevent self kill"
@Event playerTookDamage
@Hero reaper
if attacker != eventPlayer:
    eventPlayer.I = attacker
    eventPlayer.J = eventPlayer.getHealth()


@Rule "Set wraith resource HUD"
@Event eachPlayer
@Hero reaper
eventPlayer.A = 100
eventPlayer.C = 0
eventPlayer.K = 0
A = 50
B = 40
C = 30
D = 3
E = 150
hudHeader(eventPlayer, "Form: {}".format(eventPlayer.A), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "Cooldown: {}".format(eventPlayer.C), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "{}: {}".format(heroIcon(Hero.REAPER), B), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "{}: {}".format(heroIcon(Hero.REAPER), C), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "{}: {}".format(heroIcon(Hero.REAPER), D), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "{}: {}".format(heroIcon(Hero.REAPER), eventPlayer.B), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
hudHeader(eventPlayer, "Cooldown: {}".format(eventPlayer.K), Position.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


@Rule "Wraith form"
@Event eachPlayer
@Hero reaper
if eventPlayer.B:
    stopChasingVariable(eventPlayer.C)
    chase(eventPlayer.A, 0, rate=B, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.setMoveSpeed(E)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.C = D


@Rule "Normal form"
@Event eachPlayer
@Hero reaper
if not eventPlayer.B:
    chase(eventPlayer.A, 100, rate=C, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0)
    eventPlayer.setPrimaryFireEnabled(true)
    chase(eventPlayer.C, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


@Rule "Wraith heal"
@Event eachPlayer
@Hero reaper
if eventPlayer.B:
    stopHoT(eventPlayer.F)
    eventPlayer.startHoT(eventPlayer, 10000, A)
    eventPlayer.F = getLastHoT()


@Rule "Remove wraith heal"
@Event eachPlayer
@Hero reaper
if not eventPlayer.B:
    stopHoT(eventPlayer.F)


@Rule "Wraith effect"
@Event eachPlayer
@Hero reaper
if eventPlayer.B:
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.PURPLE, eventPlayer.getEyePosition() + Vector.FORWARD, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.D = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.WHITE, eventPlayer, 300, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.E = getLastCreatedEntity()


@Rule "Stop wraith effect"
@Event eachPlayer
@Hero reaper
if not eventPlayer.B:
    destroyEffect(eventPlayer.D)
    destroyEffect(eventPlayer.E)


@Rule "Start using wraith"
@Event eachPlayer
@Hero reaper
if eventPlayer.isHoldingButton(Button.ABILITY_1) and not eventPlayer.isUsingUltimate() and not eventPlayer.hasStatusEffect(Status.HACKED) and not eventPlayer.hasStatusEffect(Status.FROZEN) and not eventPlayer.hasStatusEffect(Status.ROOTED) and not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) and not eventPlayer.hasStatusEffect(Status.STUNNED) and eventPlayer.C == 0 and not eventPlayer.B:
    eventPlayer.B = true


@Rule "Stop using wraith"
@Event eachPlayer
@Hero reaper
if not eventPlayer.isHoldingButton(Button.ABILITY_1) and eventPlayer.B:
    eventPlayer.B = false


@Rule "Stop using wraith when ulting"
@Event eachPlayer
@Hero reaper
if eventPlayer.isUsingUltimate() and eventPlayer.B:
    eventPlayer.B = false


@Rule "Stop using wraith when out of juice"
@Event eachPlayer
@Hero reaper
if eventPlayer.A == 0 and eventPlayer.B:
    eventPlayer.B = false


@Rule "Leap"
@Event eachPlayer
@Hero reaper
if eventPlayer.isHoldingButton(Button.ABILITY_2) and not eventPlayer.isUsingUltimate() and not eventPlayer.hasStatusEffect(Status.HACKED) and not eventPlayer.hasStatusEffect(Status.FROZEN) and not eventPlayer.hasStatusEffect(Status.ROOTED) and not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) and not eventPlayer.hasStatusEffect(Status.STUNNED) and eventPlayer.K == 0 and not eventPlayer.B:
    eventPlayer.K = 3
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


@Rule "Leap cooldown"
@Event eachPlayer
@Hero reaper
if eventPlayer.K > 0:
    chase(eventPlayer.K, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)