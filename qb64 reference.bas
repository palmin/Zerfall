
'SCREEN SETUP
LPS = 59.94

CHDIR "./programs/z/backgrounds"
SCREEN _NEWIMAGE(1920, 1080, 32)
_TITLE "BUNKER"
map& = _LOADIMAGE("bunker-bitmap.png", 32)
mainmap& = _LOADIMAGE("bunker-bitmap.png", 32)
bitmap& = _LOADIMAGE("bunker-bitmap.png", 32)
openmap& = _LOADIMAGE("bunker-bitmap.png", 32)
DIM m AS _MEM
m = _MEMIMAGE(bitmap&)
_SOURCE bitmap&

'IMAGE SETUP
CHDIR "../sprites"
pSpritesheet& = _LOADIMAGE("sprite-sheet.png")
zSprite& = _LOADIMAGE("zombie-temp.png")
DIM pSprite AS _UNSIGNED _BIT * 3
'DATA SETUP
CHDIR "../data"
OPEN "bunker-rooms.dat" FOR INPUT AS #1: OPEN "gun-list.dat" FOR INPUT AS #2
DIM doors(1 TO 4, 1 TO 12) AS INTEGER
FOR i = 1 TO 12
    FOR j = 1 TO 4
        INPUT #1, doors(j, i)
    NEXT
NEXT

CHDIR "../music"
WBD& = _SNDOPEN("wbd.ogg", "SYNC,VOL")

CHDIR "../sounds"
dSmash& = _SNDOPEN("door-smash.ogg", "SYNC")
dFire& = _SNDOPEN("dry-fire.ogg", "SYNC")

CHDIR "../fonts"
trFont& = _LOADFONT("Typerighter.ttf", 42, "MONOSPACE")
shFont& = _LOADFONT("Shogun.ttf", 64)
meFont& = _LOADFONT("Menlo.ttf", 14, "MONOSPACE")
orFont& = _LOADFONT("Orbitron.ttf", 36)

DIM posi(3, 8) AS INTEGER 'posi(0) is x, posi(1) is y, posi(2) is x + w, and posi(3) is y + h
posi(0, 0) = INT((1920 - 175) / 2)
posi(1, 0) = 335
DIM pCol(0 TO 4) AS _UNSIGNED _BIT
DIM pScore AS _UNSIGNED _INTEGER64
DIM red AS _UNSIGNED LONG: red = _RGB32(255, 0, 0)
DIM green AS _UNSIGNED LONG: green = _RGB32(0, 255, 0)
DIM blue AS _UNSIGNED LONG: blue = _RGB32(0, 0, 255)
DIM black AS _UNSIGNED LONG: black = _RGB32(0, 0, 0)
DIM white AS _UNSIGNED LONG: white = _RGB32(255, 255, 255)

'GUN SETUP
CHDIR ".."
DIM gunList(1 TO 18, 0 TO 2) AS INTEGER 'gunList(*,0) is firing mode, gunList(*,1) is clip capacity, gunList(*,2) is LPR
DIM pGun AS INTEGER: pGun = 1
FOR k = 0 TO 2
    FOR i = 1 TO 18
        INPUT #2, j
        IF k = 2 AND j <= 3600 THEN gunList(i, k) = _CEIL(60 * LPS / j): ELSE IF k = 1 THEN gunList(i, k) = j: ELSE gunList(i, k) = -j
    NEXT
NEXT
CLOSE #2
CONST AK47 = 1: CONST AUG = 2: CONST M9 = 3:
CONST Drgv = 4: CONST FAL = 5: CONST FMS = 6:
CONST G3 = 7: CONST p08 = 8: CONST M1911 = 9:
CONST BAR = 10: CONST M40 = 11: CONST M60 = 12:
CONST Ster = 13: CONST PPK = 14: CONST RPK = 15:
CONST St63 = 16: CONST Tommy = 17: CONST Uzi = 18:
CONST Shot = 0: CONST Reload = 1: CONST Clip = 1: CONST Rate = 2
pClip = gunList(pGun, Clip)
DIM gunSound(1 TO 18, 1) AS LONG
gunSound(AK47, Shot) = _SNDOPEN("1.ogg", "SYNC"): gunSound(AK47, Reload) = _SNDOPEN("1-reload.ogg", "SYNC")
gunSound(AUG, Shot) = _SNDOPEN("2.ogg", "SYNC"): gunSound(AUG, Reload) = _SNDOPEN("2-reload.ogg", "SYNC")
gunSound(M9, Shot) = _SNDOPEN("3.ogg", "SYNC") ': gunSound(M9, Reload) = _SNDOPEN("3-reload.ogg", "SYNC")
gunSound(Drgv, Shot) = _SNDOPEN("4.ogg", "SYNC") ': gunSound(Drgv, Reload) = _SNDOPEN("4-reload.ogg", "SYNC")
gunSound(FAL, Shot) = _SNDOPEN("5.ogg", "SYNC") ': gunSound(FAL, Reload) = _SNDOPEN("5-reload.ogg", "SYNC")
'gunSound(FMS, Shot) = _SNDOPEN("6.ogg", "SYNC"): gunSound(FMS, Reload) = _SNDOPEN("6-reload.ogg", "SYNC")
gunSound(G3, Shot) = _SNDOPEN("7.ogg", "SYNC") ': gunSound(G3, Reload) = _SNDOPEN("7-reload.ogg", "SYNC")
gunSound(M1911, Shot) = _SNDOPEN("9.ogg", "SYNC"): gunSound(M1911, Reload) = _SNDOPEN("9-reload.ogg", "SYNC")
gunSound(BAR, Shot) = _SNDOPEN("10.ogg", "SYNC"): gunSound(BAR, Reload) = _SNDOPEN("10-reload.ogg", "SYNC")
gunSound(M60, Shot) = _SNDOPEN("12.ogg", "SYNC"): gunSound(M60, Reload) = _SNDOPEN("12-reload.ogg", "SYNC")
gunSound(Ster, Shot) = _SNDOPEN("13.ogg", "SYNC"): gunSound(Ster, Reload) = _SNDOPEN("13-reload.ogg", "SYNC")
gunSound(PPK, Shot) = _SNDOPEN("14.ogg", "SYNC"): gunSound(PPK, Reload) = _SNDOPEN("14-reload.ogg", "SYNC")
gunSound(RPK, Shot) = _SNDOPEN("15.ogg", "SYNC") ': gunSound(RPK, Reload) = _SNDOPEN("15-reload.ogg", "SYNC")
gunSound(Tommy, Shot) = _SNDOPEN("17.ogg", "SYNC"): gunSound(Tommy, Reload) = _SNDOPEN("17-reload.ogg", "SYNC")
pGunshot& = _SNDCOPY(gunSound(pGun, Shot))
pReload& = _SNDCOPY(gunSound(pGun, Reload))

_SNDVOL WBD&, .75

'KEY SETUP
DIM keyW AS _BIT: DIM keyA AS _BIT: DIM keyS AS _BIT: DIM keyD AS _BIT: DIM keyE AS _BIT: DIM keyR AS _BIT: DIM keySPC AS _BIT

_PUTIMAGE (0, 0), map&

'MAIN LOOP
DO
    '_LIMIT LPS

    _FONT meFont&
    n# = TIMER(1)
    z = z + 1
    LINE (0, 100)-(_PRINTWIDTH(STR$(x)), 200), _RGB(0, 0, 0), BF
    _PRINTSTRING (1, 100), STR$(z)
    _PRINTSTRING (1, 150), STR$(n#)
    IF n# > t# THEN _PRINTSTRING (1, 200), STR$(z - w): w = z: t# = n#

    posi(2, 0) = posi(0, 0) + 175
    posi(3, 0) = posi(1, 0) + 161
    pColX = posi(0, 0) + 28
    pColW = posi(2, 0) - 28
    keyW = _KEYDOWN(87) XOR _KEYDOWN(119)
    keyA = _KEYDOWN(65) XOR _KEYDOWN(97)
    keyS = _KEYDOWN(83) XOR _KEYDOWN(115)
    keyD = _KEYDOWN(68) XOR _KEYDOWN(100)
    keyE = _KEYDOWN(69) XOR _KEYDOWN(101)
    keyR = _KEYDOWN(82) XOR _KEYDOWN(114)
    keyY = _KEYDOWN(89) XOR _KEYDOWN(121)
    lastkeySPC = keySPC
    keySPC = _KEYDOWN(32)


    'COLLISION DETECTION
    ERASE pCol
    dx = -1
    dy = -1

    _PUTIMAGE (posi(0, 0), posi(1, 0)), map&, 0, (posi(0, 0), posi(1, 0))-(posi(2, 0), posi(3, 0))

    FOR y = posi(1, 0) TO posi(3, 0)
        FOR x = pColX - 5 TO pColX
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(255, 0, 0) THEN dx = x: dy = y: pCol(1) = 1
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 0) THEN pCol(1) = 1
        NEXT
    NEXT 'Left Bound: pCol(1)
    FOR x = pColW TO pColW + 5: FOR y = posi(1, 0) TO posi(3, 0)
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(255, 0, 0) THEN dx = x: dy = y: pCol(2) = 1
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 0) THEN pCol(2) = 1
    NEXT: NEXT 'Right Bound: pCol(2)
    FOR x = pColX TO pColW: FOR y = posi(3, 0) TO posi(3, 0) + ABS(grav)
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 255) THEN pCol(4) = 1
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 0) THEN pCol(3) = 1
    NEXT: NEXT 'Lower Bound: pCol(3)
    FOR x = pColX TO pColW: FOR y = posi(1, 0) TO posi(1, 0) - ABS(grav) STEP -1
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 255) THEN pCol(4) = 1
            IF _MEMGET(m, m.OFFSET + (y * 1920 + x) * 4, LONG) = _RGB32(0, 0, 0) THEN pCol(0) = 1
    NEXT: NEXT 'Upper Bound: pCol(4)
    'END COLLISION

    IF pCol(3) = 0 THEN posi(1, 0) = posi(1, 0) + grav: grav = grav + 1 ELSE grav = 1

    'MOVEMENT
    IF pCol(1) = 0 AND keyA = -1 THEN posi(0, 0) = posi(0, 0) - 4
    IF pCol(2) = 0 AND keyD = -1 THEN posi(0, 0) = posi(0, 0) + 4
    IF keyW = -1 THEN
        IF pCol(3) = 1 THEN grav = -7: posi(1, 0) = posi(1, 0) - 7
        IF pCol(0) = 1 THEN grav = -4
    END IF
    IF pCol(3) = 1 THEN
        IF keyA = -1 AND keySPC = 0 OR pClip = 0 AND pSprite = 4 THEN pSprite = 0
        IF keyD = -1 AND keySPC = 0 OR pClip = 0 AND pSprite = 6 THEN pSprite = 2
        IF grav = 1 AND (pSprite / 2 <> INT(pSprite / 2)) THEN pSprite = pSprite - 1
    END IF
    IF grav <> 1 AND (pSprite / 2 = INT(pSprite / 2)) AND keyW = -1 THEN pSprite = pSprite + 1
    'END MOVEMENT

    'HUD
    IF _SNDPLAYING(gunSound(pGun, Reload)) = 0 AND pClip <> -1 THEN
        LINE (1600, 1000)-(1920, 1080), black, BF
        _FONT orFont&
        _PRINTSTRING (1600, 1000), STR$(pClip) + "/" + STR$(gunList(pGun, 1)) + "  " + STR$(pGun)
    END IF
    LINE (0, 0)-(_PRINTWIDTH(STR$(pScore)), 48), black, BF: _PRINTSTRING (1, 1), STR$(pScore)
    'END HUD

    'GUNFIRE
    IF _KEYHIT = 13 THEN
        IF pGun = 18 THEN pGun = 1 ELSE pGun = pGun + 1
        pGunshot& = _SNDCOPY(gunSound(pGun, Shot))
        pReload& = _SNDCOPY(gunSound(pGun, Reload))
        pClip = gunList(pGun, 1)
    ELSEIF pClip = -1 AND _SNDPLAYING(pReload&) = 0 THEN pClip = gunList(pGun, 1)
    END IF
    IF LPR < gunList(pGun, 2) AND keySPC = -1 THEN LPR = LPR + 1 ELSE IF LPR >= gunList(pGun, 2) THEN LPR = 1
    IF keySPC = -1 AND (gunList(pGun, 0) = -1 OR lastkeySPC = 0 AND gunList(pGun, 0) = 0) AND LPR = 1 AND pClip > 0 AND _SNDPLAYING(pReload&) = 0 THEN
        pClip = pClip - 1
        IF pSprite < 4 THEN pSprite = pSprite + 4
        _SNDPLAYCOPY pGunshot&
        _SOURCE bitmap&
        IF pSprite = (0 OR 1 OR 4 OR 5) THEN
            FOR x = posi(0, 0) TO 0 STEP -1
                IF POINT(x, posi(1, 0) + 75) = _RGB32(0, 0, 0) OR POINT(x, posi(1, 0) + 75) = _RGB32(255, 0, 0) THEN EXIT FOR
            NEXT
        ELSE
            FOR x = posi(0, 0) TO 1920 STEP 1
                IF POINT(x, posi(1, 0) + 75) = _RGB32(0, 0, 0) OR POINT(x, posi(1, 0) + 75) = _RGB32(255, 0, 0) THEN EXIT FOR
            NEXT
        END IF
    END IF
    IF keyR AND _SNDPLAYING(pReload&) = 0 THEN _SNDPLAY pReload&: pClip = -1
    IF keySPC = -1 AND lastkeySPC = 0 AND pClip = 0 AND LPR = 1 THEN _SNDPLAY dFire&
    'END GUNFIRE

    _PUTIMAGE (posi(0, 0), posi(1, 0)), pSpritesheet&, 0, (pSprite * 175, 0)-((pSprite + 1) * 175 - 1, 161)
    IF keyE AND dx <> -1 THEN GOSUB DOORS
    IF _KEYDOWN(69) AND _KEYDOWN(77) AND _KEYDOWN(73) AND _KEYDOWN(78) AND _SNDPLAYING(WBD&) = 0 THEN _SNDPLAY WBD&


    _DISPLAY

LOOP UNTIL _KEYDOWN(27): IF _KEYDOWN(27) THEN SYSTEM


DOORS: 'DOOR SEQUENCE
_SNDPLAY dSmash&
_DEST bitmap&
FOR i = 1 TO 6: IF dx >= doors(1, i) AND dx <= doors(3, i) AND dy >= doors(2, i) AND dy <= doors(4, i) THEN
        L = i
        EXIT FOR
    END IF
NEXT
LINE (doors(1, L), doors(2, L))-(doors(3, L), doors(4, L)), green, BF
_PUTIMAGE (doors(1, L + 6), doors(2, L + 6)), mainmap&, 0, (doors(1, L + 6), doors(2, L + 6))-(doors(3, L + 6), doors(4, L + 6))
_PUTIMAGE (doors(1, L + 6), doors(2, L + 6)), mainmap&, map&, (doors(1, L + 6), doors(2, L + 6))-(doors(3, L + 6), doors(4, L + 6))
_PUTIMAGE (doors(1, L) - 2, doors(2, L)), openmap&, map&, (doors(1, L) - 2, doors(2, L))-(doors(3, L) + 2, doors(4, L))
_PUTIMAGE (doors(1, L) - 2, doors(2, L)), openmap&, 0, (doors(1, L) - 2, doors(2, L))-(doors(3, L) + 2, doors(4, L))
_DEST 0
RETURN
'END DOOR SEQUENCE


