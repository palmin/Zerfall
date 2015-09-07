
'SCREEN SETUP
CHDIR "./programs/z/backgrounds"
SCREEN _NEWIMAGE(1920, 1080, 32)
map& = _LOADIMAGE("bunker-startmap.png", 32)
mainmap& = _LOADIMAGE("bunker-map.png", 32)
bitmap& = _LOADIMAGE("bunker-bitmap.bmp", 256)
openmap& = _LOADIMAGE("bunker-openmap.png", 32)
_SOURCE bitmap&
CHDIR "../sprites"
pSpritesheet& = _LOADIMAGE("sprite-sheet.png")
DIM pSprite AS _UNSIGNED _BIT * 2

'DOOR SETUP
CHDIR "../data"
OPEN "bunker-rooms.dat" FOR INPUT AS #1
DIM doors(1 TO 4, 1 TO 12) AS INTEGER
FOR i = 1 TO 12
    FOR j = 1 TO 4
        INPUT #1, doors(j, i)
    NEXT
NEXT

'SOUND SETUP
CHDIR "../sounds"
cReg& = _SNDOPEN("cha-ching.ogg", "SYNC")
dSmash& = _SNDOPEN("door-smash.ogg", "SYNC")
wCreak& = _SNDOPEN("wall-creak.ogg", "SYNC")
fCreak& = _SNDOPEN("floor-creak.ogg", "SYNC")
_SNDVOL wDrip&, .25

'FONT SETUP
CHDIR "../fonts"
trFont& = _LOADFONT("Typerighter.ttf", 42, "MONOSPACE")
shFont& = _LOADFONT("Shogun.ttf", 64)
meFont& = _LOADFONT("Menlo.ttf", 14)

'VARIABLE SETUP
DIM posi(3, 8) AS INTEGER
'posi(0) is x, posi(1) is y, posi(2) is x + w, and posi(3) is y + h
posi(0, 0) = INT((1920 - _WIDTH(pSpritesheet&)) / 2)
posi(1, 0) = 335
DIM pCol(0 TO 4) AS _UNSIGNED _BIT
DIM pScore AS _INTEGER64
RANDOMIZE USING TIMER

_PUTIMAGE (0, 0), map&, 0

'MAIN LOOP
DO
    _LIMIT 60

    posi(2, 0) = posi(0, 0) + 125
    posi(3, 0) = posi(1, 0) + 161

    'COLLISION DETECTION
    ERASE pCol
    ptColor& = 0
    dx = -1
    dy = -1

    _PUTIMAGE (posi(0, 0), posi(1, 0)), map&, 0, (posi(0, 0), posi(1, 0))-(posi(2, 0), posi(3, 0))

    FOR x = posi(0, 0) - 4 TO posi(0, 0): FOR y = posi(1, 0) TO posi(3, 0) STEP 2
            ptColor& = POINT(x, y)
            IF dx = -1 AND ptColor& = &HFFFF0000 THEN dx = x: dy = y
            IF (ptColor& = &HFF000000 OR ptColor& = &HFFFF0000) THEN pCol(1) = 1: EXIT FOR: EXIT FOR
    NEXT: NEXT 'Left Bound: pCol(1)
    FOR x = posi(2, 0) TO posi(2, 0) + 4: FOR y = posi(1, 0) TO posi(3, 0) STEP 2
            ptColor& = POINT(x, y)
            IF dx = -1 AND ptColor& = &HFFFF0000 THEN dx = x: dy = y
            IF ptColor& = &HFF000000 OR ptColor& = &HFFFF0000 THEN pCol(2) = 1: EXIT FOR: EXIT FOR
    NEXT: NEXT 'Right Bound: pCol(2)
    FOR x = posi(0, 0) TO posi(2, 0) STEP 2: FOR y = posi(3, 0) TO posi(3, 0) + ABS(grav)
            ptColor& = POINT(x, y)
            IF ptColor& = &HFF0000FF THEN pCol(0) = 1
            IF ptColor& = &HFF000000 THEN pCol(3) = 1: EXIT FOR: EXIT FOR
    NEXT: NEXT 'Lower Bound: pCol(3)
    FOR x = posi(0, 0) TO posi(2, 0) STEP 2: FOR y = posi(1, 0) TO posi(1, 0) - ABS(grav) STEP -1
            ptColor& = POINT(x, y)
            IF ptColor& = &HFF0000FF THEN pCol(0) = 1
            IF ptColor& = &HFF000000 THEN pCol(4) = 1: posi(1, 0) = y + ABS(grav): grav = 6: EXIT FOR: EXIT FOR
    NEXT: NEXT 'Upper Bound: pCol(4)



    IF pCol(3) = 0 THEN posi(1, 0) = posi(1, 0) + grav: grav = grav + 1 ELSE grav = 1

    'MOVEMENT
    IF _KEYDOWN(119) = -1 AND pCol(3) = 1 THEN grav = -7: posi(1, 0) = posi(1, 0) - 4
    IF _KEYDOWN(119) = -1 AND pCol(0) = 1 THEN grav = -4
    IF _KEYDOWN(97) = -1 AND pCol(3) = 1 THEN pSprite = 0
    IF pCol(1) = 0 AND _KEYDOWN(97) = -1 THEN posi(0, 0) = posi(0, 0) - 5

    IF pCol(2) = 0 AND _KEYDOWN(100) = -1 THEN posi(0, 0) = posi(0, 0) + 5: IF _KEYDOWN(100) = -1 AND pCol(3) = 1 THEN pSprite = 2
    IF (pSprite = 0 OR pSprite = 2) AND _KEYDOWN(119) = -1 AND grav <> 1 THEN pSprite = pSprite + 1: IF grav = 1 AND (pSprite = 1 OR pSprite = 3) THEN pSprite = pSprite - 1
    'END MOVEMENT

    _PUTIMAGE (posi(0, 0), posi(1, 0)), pSpritesheet&, 0, (pSprite * 125, 0)-((pSprite + 1) * 125 - 1, 161)
    IF _KEYDOWN(59) = -1 AND dx <> -1 THEN GOSUB DOORS

    _DISPLAY

LOOP


DOORS: 'DOOR SEQUENCE
_SNDPLAY dSmash&
_DEST bitmap&
FOR i = 1 TO 6: IF dx >= doors(1, i) AND dx <= doors(3, i) AND dy >= doors(2, i) AND dy <= doors(4, i) THEN: l = i: EXIT FOR
NEXT
LINE (doors(1, l), doors(2, l))-(doors(3, l), doors(4, l)), _RGB(0, 255, 0), BF
_PUTIMAGE (doors(1, l + 6), doors(2, l + 6))-(doors(3, l + 6), doors(4, l + 6)), mainmap&, 0, (doors(1, l + 6), doors(2, l + 6))-(doors(3, l + 6), doors(4, l + 6))
_PUTIMAGE (doors(1, l + 6), doors(2, l + 6))-(doors(3, l + 6), doors(4, l + 6)), mainmap&, map&, (doors(1, l + 6), doors(2, l + 6))-(doors(3, l + 6), doors(4, l + 6))
_PUTIMAGE (doors(1, l) - 2, doors(2, l))-(doors(3, l) + 2, doors(4, l)), openmap&, map&, (doors(1, l) - 2, doors(2, l))-(doors(3, l) + 2, doors(4, l))
_PUTIMAGE (doors(1, l) - 2, doors(2, l))-(doors(3, l) + 2, doors(4, l)), openmap&, 0, (doors(1, l) - 2, doors(2, l))-(doors(3, l) + 2, doors(4, l))
_DEST 0
RETURN


