#include QMK_KEYBOARD_H

/* THIS FILE WAS GENERATED!
 *
 * This file was generated by qmk json2c. You may or may not want to
 * edit it directly.
 */

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT_split_3x6_3(KC_ESC, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U,
                             KC_I, KC_O, KC_P, KC_MINS, KC_LSFT, KC_A, KC_S,
                             KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_SCLN,
                             KC_TAB, KC_LCTL, KC_Z, KC_X, KC_C, KC_V, KC_B,
                             KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_EQL,
                             KC_LGUI, MO(1), KC_SPC, KC_ENT, MO(2), KC_BSPC),
    [1] = LAYOUT_split_3x6_3(KC_LALT, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7,
                             KC_8, KC_9, KC_0, KC_GRV, KC_LSFT, KC_NO, KC_NO,
                             KC_NO, KC_NO, KC_NO, KC_LEFT, KC_DOWN, KC_UP,
                             KC_RGHT, KC_HOME, KC_TAB, KC_LCTL, KC_NO, KC_NO,
                             KC_NO, KC_PGUP, KC_PGDN, KC_NO, KC_NO, KC_COMM,
                             KC_DOT, KC_END, KC_DEL, KC_LGUI, KC_TRNS, KC_NO,
                             KC_ENT, MO(3), OSM(MOD_RALT)),
    [2] = LAYOUT_split_3x6_3(
        KC_ESC, KC_EXLM, KC_AT, KC_HASH, KC_DLR, KC_PERC, KC_CIRC, KC_AMPR,
        KC_ASTR, KC_LPRN, KC_RPRN, KC_PSCR, KC_LSFT, KC_NO, KC_GRV, KC_LBRC,
        KC_LCBR, KC_QUOT, KC_DQUO, KC_RCBR, KC_RBRC, KC_BSLS, KC_NO, KC_UP,
        KC_LCTL, KC_NO, KC_NO, KC_NO, KC_NO, KC_MINS, KC_EQL, KC_NO, KC_NO,
        KC_NO, KC_NO, KC_DOWN, KC_LGUI, MO(3), LCA(KC_NO), KC_NO, KC_TRNS,
        KC_RALT),
    [3] = LAYOUT_split_3x6_3(
        KC_LALT, KC_NO, KC_F1, KC_F2, KC_F3, KC_NO, KC_NO, KC_F7, KC_F8, KC_F9,
        KC_NO, RGB_TOG, RGB_MOD, RGB_HUI, KC_F4, KC_F5, KC_F6, KC_WH_D, KC_WH_U,
        KC_F10, KC_F11, KC_F12, RGB_SAI, RGB_VAI, RGB_RMOD, RGB_HUD, KC_NO,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, RGB_SAD, RGB_VAD,
        KC_LGUI, KC_TRNS, KC_NO, KC_NO, KC_TRNS, KC_RALT)};
