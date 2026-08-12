import Foundation
import SwiftUI

// MARK: - Appraisal Result (from Claude API)

struct AppraisalResult: Codable, Identifiable {
    let id: UUID

    let overall: Int
    let eraScore: Int
    let eraNote: String
    let glazeScore: Int
    let glazeNote: String
    let shapeScore: Int
    let shapeNote: String
    let patternScore: Int
    let patternNote: String
    let bottomScore: Int
    let bottomNote: String
    let wearScore: Int
    let wearNote: String
    let name: String
    let dynasty: String
    let type: String
    let summary: String

    enum CodingKeys: String, CodingKey {
        case overall
        case eraScore = "era_score"
        case eraNote = "era_note"
        case glazeScore = "glaze_score"
        case glazeNote = "glaze_note"
        case shapeScore = "shape_score"
        case shapeNote = "shape_note"
        case patternScore = "pattern_score"
        case patternNote = "pattern_note"
        case bottomScore = "bottom_score"
        case bottomNote = "bottom_note"
        case wearScore = "wear_score"
        case wearNote = "wear_note"
        case name, dynasty, type, summary
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        overall = try c.decode(Int.self, forKey: .overall)
        eraScore = try c.decode(Int.self, forKey: .eraScore)
        eraNote = try c.decode(String.self, forKey: .eraNote)
        glazeScore = try c.decode(Int.self, forKey: .glazeScore)
        glazeNote = try c.decode(String.self, forKey: .glazeNote)
        shapeScore = try c.decode(Int.self, forKey: .shapeScore)
        shapeNote = try c.decode(String.self, forKey: .shapeNote)
        patternScore = try c.decode(Int.self, forKey: .patternScore)
        patternNote = try c.decode(String.self, forKey: .patternNote)
        bottomScore = try c.decode(Int.self, forKey: .bottomScore)
        bottomNote = try c.decode(String.self, forKey: .bottomNote)
        wearScore = try c.decode(Int.self, forKey: .wearScore)
        wearNote = try c.decode(String.self, forKey: .wearNote)
        name = try c.decode(String.self, forKey: .name)
        dynasty = try c.decode(String.self, forKey: .dynasty)
        type = try c.decode(String.self, forKey: .type)
        summary = try c.decode(String.self, forKey: .summary)
    }

    init(
        overall: Int, eraScore: Int, eraNote: String,
        glazeScore: Int, glazeNote: String, shapeScore: Int, shapeNote: String,
        patternScore: Int, patternNote: String, bottomScore: Int, bottomNote: String,
        wearScore: Int, wearNote: String, name: String, dynasty: String,
        type: String, summary: String
    ) {
        self.id = UUID()
        self.overall = overall
        self.eraScore = eraScore; self.eraNote = eraNote
        self.glazeScore = glazeScore; self.glazeNote = glazeNote
        self.shapeScore = shapeScore; self.shapeNote = shapeNote
        self.patternScore = patternScore; self.patternNote = patternNote
        self.bottomScore = bottomScore; self.bottomNote = bottomNote
        self.wearScore = wearScore; self.wearNote = wearNote
        self.name = name; self.dynasty = dynasty
        self.type = type; self.summary = summary
    }

    /// All dimension scores as an array
    var dimensionScores: [(key: String, label: String, icon: String, score: Int, note: String)] {
        [
            ("era", "年代判断", "⏳", eraScore, eraNote),
            ("glaze", "釉色工艺", "✦", glazeScore, glazeNote),
            ("shape", "器型特征", "◎", shapeScore, shapeNote),
            ("pattern", "纹饰风格", "❋", patternScore, patternNote),
            ("bottom", "底款特征", "印", bottomScore, bottomNote),
            ("wear", "老化痕迹", "◈", wearScore, wearNote),
        ]
    }

    // MARK: Mock data for previews
    static let mock = AppraisalResult(
        overall: 87,
        eraScore: 88, eraNote: "器型、釉色与明永乐特征高度吻合",
        glazeScore: 92, glazeNote: "甜白釉肥润，呈半透明玻璃质感，符合永乐甜白特征",
        shapeScore: 85, shapeNote: "压手杯经典造型，口沿微撇，手感沉稳",
        patternScore: 90, patternNote: "青花发色浓艳，铁锈斑分布自然，苏麻离青料特征明显",
        bottomScore: 78, bottomNote: "「永乐年制」篆书款，字迹略模糊但风格与时代一致",
        wearScore: 86, wearNote: "使用痕迹自然，包浆温润，底足火石红特征明显",
        name: "青花压手杯",
        dynasty: "明永乐",
        type: "压手杯",
        summary: "此件青花压手杯整体特征与明永乐时期官窑器物高度吻合。甜白釉质地肥润，青花发色浓艳带铁锈斑，为典型苏麻离青料特征。器型端庄规整，手感沉稳。底款稍模糊但风格一致，建议结合实物上手进一步确认。"
    )
}

// MARK: - Appraisal Record (for history)

struct AppraisalRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let imagePath: String?
    let result: AppraisalResult

    init(result: AppraisalResult, imagePath: String? = nil) {
        self.id = UUID()
        self.date = Date()
        self.result = result
        self.imagePath = imagePath
    }
}

// MARK: - Knowledge Items

struct KilnInfo: Identifiable {
    let id = UUID()
    let name: String
    let era: String
    let location: String
    let tag: String
    let emoji: String
    let description: String

    static let samples: [KilnInfo] = [
        KilnInfo(name: "汝窑", era: "北宋", location: "河南宝丰", tag: "五大名窑",
                 emoji: "🏺", description: "汝窑为宋代五大名窑之首，以天青色釉闻名于世。"),
        KilnInfo(name: "景德镇窑", era: "宋—清", location: "江西景德镇", tag: "青花瓷都",
                 emoji: "🍶", description: "中国制瓷史上最重要的窑场，青花瓷的发源地。"),
        KilnInfo(name: "龙泉窑", era: "南宋", location: "浙江龙泉", tag: "梅子青",
                 emoji: "🫖", description: "以粉青、梅子青釉色著称的青瓷名窑。"),
        KilnInfo(name: "建窑", era: "宋", location: "福建建阳", tag: "兔毫盏",
                 emoji: "🍵", description: "以黑釉盏闻名，兔毫、油滴、曜变等名品辈出。"),
        KilnInfo(name: "定窑", era: "北宋", location: "河北曲阳", tag: "五大名窑",
                 emoji: "🏺", description: "以白瓷著称，刻花、印花装饰精美。"),
        KilnInfo(name: "钧窑", era: "北宋", location: "河南禹州", tag: "窑变釉",
                 emoji: "🫖", description: "以窑变釉色闻名，入窑一色出窑万彩。"),
    ]
}
