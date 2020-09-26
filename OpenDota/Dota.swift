//
//  Dota.swift
//  OpenDota
//
//  Created by docotel on 24/09/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation

// MARK: - DotaElement
struct DotaElement: Codable {
    let baseAttackMax: Int
    let icon: String
    let nullWin, the5_Win, baseStr, id: Int
    let name: String
    let the8_Win, baseHealth, attackRange, the3_Win: Int
    let the7_Pick: Int
    let agiGain, baseArmor: Double
    let cmEnabled: Bool
    let primaryAttr: String
    let baseHealthRegen: Double?
    let the2_Pick, the6_Pick: Int
    let attackRate, intGain: Double
    let baseAttackMin: Int
    let attackType: String
    let the3_Pick: Int
    let turnRate: Double
    let heroID, the7_Win, proBan, baseInt: Int
    let baseAgi, nullPick, the8_Pick, the4_Win: Int
    let baseMana, legs, baseMr, the6_Win: Int
    let roles: [String]
    let img: String
    let strGain: Double
    let the2_Win, projectileSpeed, the5_Pick, moveSpeed: Int
    let localizedName: String
    let the1_Win, the4_Pick, the1_Pick, proWin: Int
    let proPick: Int
    let baseManaRegen: Double

    enum CodingKeys: String, CodingKey {
        case baseAttackMax = "base_attack_max"
        case icon
        case nullWin = "null_win"
        case the5_Win = "5_win"
        case baseStr = "base_str"
        case id, name
        case the8_Win = "8_win"
        case baseHealth = "base_health"
        case attackRange = "attack_range"
        case the3_Win = "3_win"
        case the7_Pick = "7_pick"
        case agiGain = "agi_gain"
        case baseArmor = "base_armor"
        case cmEnabled = "cm_enabled"
        case primaryAttr = "primary_attr"
        case baseHealthRegen = "base_health_regen"
        case the2_Pick = "2_pick"
        case the6_Pick = "6_pick"
        case attackRate = "attack_rate"
        case intGain = "int_gain"
        case baseAttackMin = "base_attack_min"
        case attackType = "attack_type"
        case the3_Pick = "3_pick"
        case turnRate = "turn_rate"
        case heroID = "hero_id"
        case the7_Win = "7_win"
        case proBan = "pro_ban"
        case baseInt = "base_int"
        case baseAgi = "base_agi"
        case nullPick = "null_pick"
        case the8_Pick = "8_pick"
        case the4_Win = "4_win"
        case baseMana = "base_mana"
        case legs
        case baseMr = "base_mr"
        case the6_Win = "6_win"
        case roles, img
        case strGain = "str_gain"
        case the2_Win = "2_win"
        case projectileSpeed = "projectile_speed"
        case the5_Pick = "5_pick"
        case moveSpeed = "move_speed"
        case localizedName = "localized_name"
        case the1_Win = "1_win"
        case the4_Pick = "4_pick"
        case the1_Pick = "1_pick"
        case proWin = "pro_win"
        case proPick = "pro_pick"
        case baseManaRegen = "base_mana_regen"
    }
}

enum AttackType: String, Codable {
    case melee = "Melee"
    case ranged = "Ranged"
}

enum PrimaryAttr: String, Codable {
    case agi = "agi"
    case int = "int"
    case str = "str"
}

enum Role: String, Codable {
    case carry = "Carry"
    case disabler = "Disabler"
    case durable = "Durable"
    case escape = "Escape"
    case initiator = "Initiator"
    case jungler = "Jungler"
    case nuker = "Nuker"
    case pusher = "Pusher"
    case support = "Support"
}

typealias Dota = [DotaElement]
