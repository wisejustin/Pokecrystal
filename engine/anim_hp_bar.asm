_AnimateHPBar: ; d627
	call Functiond65f
	jr c, .do_player
	call Functiond670
.enemy_loop
	push bc
	push hl
	call Functiond6e2
	pop hl
	pop bc
	push af
	push bc
	push hl
	call Functiond730
	call Functiond7c9
	pop hl
	pop bc
	pop af
	jr nc, .enemy_loop
	ret

.do_player
	call Functiond670
.player_loop
	push bc
	push hl
	call Functiond6f5
	pop hl
	pop bc
	ret c
	push af
	push bc
	push hl
	call Functiond749
	call Functiond7c9
	pop hl
	pop bc
	pop af
	jr nc, .player_loop
	ret
; d65f

Functiond65f: ; d65f
	ld a, [Buffer2]
	and a
	jr nz, .player
	ld a, [Buffer1]
	cp 6 * 8
	jr nc, .player
	and a
	ret

.player
	scf
	ret
; d670

Functiond670: ; d670
; Buffer1-2: Max HP
; Buffer3-4: Old HP
; Buffer5-6: New HP
	push hl
	ld hl, Buffer1
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	call ComputeHPBarPixels
	ld a, e
	ld [wd1f1], a

	ld a, [Buffer5]
	ld c, a
	ld a, [Buffer6]
	ld b, a
	ld a, [Buffer1]
	ld e, a
	ld a, [Buffer2]
	ld d, a
	call ComputeHPBarPixels
	ld a, e
	ld [wd1f2], a

	push hl
	ld hl, Buffer3
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc b
	ld d, a
	jr c, .asm_d6c1
	ld a, [Buffer3]
	ld [wd1f5], a
	ld a, [Buffer5]
	ld [wd1f6], a
	ld bc, 1
	jr .asm_d6d9

.asm_d6c1
	ld a, [Buffer3]
	ld [wd1f6], a
	ld a, [Buffer5]
	ld [wd1f5], a
	ld a, e
	xor $ff
	inc a
	ld e, a
	ld a, d
	xor $ff
	ld d, a
	ld bc, rIE
.asm_d6d9
	ld a, d
	ld [wd1f3], a
	ld a, e
	ld [wd1f4], a
	ret
; d6e2

Functiond6e2: ; d6e2
	ld hl, wd1f1
	ld a, [wd1f2]
	cp [hl]
	jr nz, .asm_d6ed
	scf
	ret

.asm_d6ed
	ld a, c
	add [hl]
	ld [hl], a
	call Functiond839
	and a
	ret
; d6f5

Functiond6f5: ; d6f5
.asm_d6f5
	ld hl, Buffer3
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, e
	cp [hl]
	jr nz, .asm_d707
	inc hl
	ld a, d
	cp [hl]
	jr nz, .asm_d707
	scf
	ret

.asm_d707
	ld l, e
	ld h, d
	add hl, bc
	ld a, l
	ld [Buffer3], a
	ld a, h
	ld [wd1ed], a
	push hl
	push de
	push bc
	ld hl, Buffer1
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call ComputeHPBarPixels
	pop bc
	pop de
	pop hl
	ld a, e
	ld hl, wd1f1
	cp [hl]
	jr z, .asm_d6f5
	ld [hl], a
	and a
	ret
; d730

Functiond730: ; d730
	call Functiond784
	ld d, $6
	ld a, [wWhichHPBar]
	and $1
	ld b, a
	ld a, [wd1f1]
	ld e, a
	ld c, a
	push de
	call Functiond771
	pop de
	call Functiond7b4
	ret
; d749

Functiond749: ; d749
	call Functiond784
	ld a, [Buffer3]
	ld c, a
	ld a, [wd1ed]
	ld b, a
	ld a, [Buffer1]
	ld e, a
	ld a, [Buffer2]
	ld d, a
	call ComputeHPBarPixels
	ld c, e
	ld d, $6
	ld a, [wWhichHPBar]
	and $1
	ld b, a
	push de
	call Functiond771
	pop de
	call Functiond7b4
	ret
; d771

Functiond771: ; d771
	ld a, [wWhichHPBar]
	cp $2
	jr nz, .skip
	ld a, $28
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
.skip
	call DrawBattleHPBar
	ret
; d784

Functiond784: ; d784
	ld a, [wWhichHPBar]
	and a
	ret z
	cp $1
	jr z, .load_15
	ld de, $16
	jr .loaded_de

.load_15
	ld de, $15
.loaded_de
	push hl
	add hl, de
	ld a, " "
rept 2
	ld [hli], a
endr
	ld [hld], a
	dec hl
	ld a, [Buffer3]
	ld [StringBuffer2 + 1], a
	ld a, [wd1ed]
	ld [StringBuffer2], a
	ld de, StringBuffer2
	lb bc, 2, 3
	call PrintNum
	pop hl
	ret
; d7b4

Functiond7b4: ; d7b4
	ld a, [hCGB]
	and a
	ret z
	ld hl, wd1f0
	call SetHPPal
	ld a, [wd1f0]
	ld c, a
	callba ApplyHPBarPals
	ret
; d7c9

Functiond7c9: ; d7c9
	ld a, [hCGB]
	and a
	jr nz, .cgb
	call DelayFrame
	call DelayFrame
	ret

.cgb
	ld a, [wWhichHPBar]
	and a
	jr z, .load_0
	cp $1
	jr z, .load_1
	ld a, [CurPartyMon]
	cp $3
	jr nc, .c_is_1
	ld c, $0
	jr .c_is_0

.c_is_1
	ld c, $1
.c_is_0
	push af
	cp $2
	jr z, .skip_delay
	cp $5
	jr z, .skip_delay
	ld a, $2
	ld [hBGMapMode], a
	ld a, c
	ld [hBGMapThird], a
	call DelayFrame
.skip_delay
	ld a, $1
	ld [hBGMapMode], a
	ld a, c
	ld [hBGMapThird], a
	call DelayFrame
	pop af
	cp $2
	jr z, .two_frames
	cp $5
	jr z, .two_frames
	ret

.two_frames
	inc c
	ld a, $2
	ld [hBGMapMode], a
	ld a, c
	ld [hBGMapThird], a
	call DelayFrame
	ld a, $1
	ld [hBGMapMode], a
	ld a, c
	ld [hBGMapThird], a
	call DelayFrame
	ret

.load_0
	ld c, $0
	jr .finish

.load_1
	ld c, $1
.finish
	call DelayFrame
	ld a, c
	ld [hBGMapThird], a
	call DelayFrame
	ret
; d839

Functiond839: ; d839
	ld a, [Buffer1]
	ld c, a
	ld b, 0
	ld hl, 0
	ld a, [wd1f1]
	cp 6 * 8
	jr nc, .coppy_buffer
	and a
	jr z, .return_zero
	call AddNTimes
	ld b, 0
.loop
	ld a, l
	sub 6 * 8
	ld l, a
	ld a, h
	sbc $0
	ld h, a
	jr c, .done
	inc b
	jr .loop

.done
	push bc
	ld bc, $80
	add hl, bc
	pop bc
	ld a, l
	sub 6 * 8
	ld l, a
	ld a, h
	sbc $0
	ld h, a
	jr c, .no_carry
	inc b
.no_carry
	ld a, [wd1f5]
	cp b
	jr nc, .finish
	ld a, [wd1f6]
	cp b
	jr c, .finish
	ld a, b
.finish
	ld [Buffer3], a
	ret

.return_zero
	xor a
	ld [Buffer3], a
	ret

.coppy_buffer
	ld a, [Buffer1]
	ld [Buffer3], a
	ret
; d88c
