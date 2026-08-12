# 瓷鉴 CiJian

> 古陶瓷 AI 智能鉴定 · BIDITECH 碧帝数据科技

<p align="center">
  <strong>🏺 AI-Powered Chinese Ceramics Authentication</strong>
</p>

---

## 功能

- **📷 拍照鉴定** — 拍摄或选择瓷器照片，AI 实时分析
- **🔍 六维评估** — 年代判断、釉色工艺、器型特征、纹饰风格、底款特征、老化痕迹
- **📊 可信度评分** — 综合百分比评分 + 真伪判定
- **📋 鉴定报告** — 专业鉴定意见 + 一键分享
- **📚 知识库** — 窑口图鉴、朝代特征、釉色辞典
- **👤 个人收藏** — 鉴定历史 + 藏品管理

## 技术栈

- **SwiftUI** — iOS 17+
- **Claude API** — Anthropic Claude Sonnet 4.6 视觉分析
- **PhotosUI** — 系统相册集成
- **AVFoundation** — 相机拍摄

## 快速开始

### 前置条件

- macOS 14+ & Xcode 15+
- iOS 17+ 设备或模拟器
- [Anthropic API Key](https://console.anthropic.com/)

### 方式一：XcodeGen（推荐）

```bash
# 安装 XcodeGen
brew install xcodegen

# 生成 Xcode 项目
cd CiJian
xcodegen generate

# 打开项目
open CiJian.xcodeproj
```

### 方式二：手动创建

1. 打开 Xcode → File → New → Project → iOS App
2. Product Name: `CiJian`, Interface: `SwiftUI`, Language: `Swift`
3. 将 `CiJian/` 目录下所有 `.swift` 文件拖入项目
4. 在 Info.plist 添加相机和相册权限描述

### 配置 API Key

应用内 → 鉴定页 → 右上角齿轮 ⚙️ → 填入 Anthropic API Key

> API Key 仅存储在本地设备，不会上传到任何服务器。

## 项目结构

```
CiJian/
├── CiJianApp.swift          # App 入口
├── Theme/
│   └── DesignSystem.swift    # 设计系统（色彩、字体、布局）
├── Models/
│   └── AppraisalModels.swift # 数据模型
├── Services/
│   └── ClaudeAPIService.swift # Claude API 集成
├── Views/
│   ├── ContentView.swift     # 主导航（TabView）
│   ├── SplashView.swift      # 启动页
│   ├── HomeView.swift        # 首页
│   ├── CaptureView.swift     # 拍照鉴定
│   ├── ResultView.swift      # 鉴定报告
│   ├── KnowledgeView.swift   # 知识库
│   └── ProfileView.swift     # 个人中心
├── Components/
│   └── SharedComponents.swift # 共享 UI 组件
└── Assets.xcassets/          # 资源文件
```

## 设计规范

| 色彩 | 名称 | Hex |
|------|------|-----|
| ⬛ | 墨玉 (背景) | `#0F0F1A` |
| 🟡 | 古金 (强调) | `#C9A96E` |
| ⬜ | 象牙白 (文本) | `#F0EBE1` |
| 🟢 | 青瓷绿 (可信) | `#7A9E7E` |
| 🔴 | 印泥红 (疑伪) | `#A23020` |
| 🔵 | 钴蓝 (信息) | `#5B7FA6` |

**评分色阶**: 70-100% 青瓷绿 → 40-69% 古金 → 0-39% 印泥红

## License

Proprietary — 上海碧帝数据科技有限公司 © 2026

---

<p align="center">
  <sub>Built with ❤️ by BIDITECH · Powered by Claude</sub>
</p>
