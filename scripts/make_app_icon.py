"""生成瓷鉴 App 图标：墨玉底 + 古金梅瓶剪影。

App Store 要求 1024x1024、无 alpha 通道、无圆角（圆角由系统裁切）。
按 4 倍超采样绘制再缩放，得到平滑边缘。
"""
from PIL import Image, ImageDraw, ImageFilter

S = 1024
SS = 4                      # 超采样倍数
W = S * SS

INK   = (0x0F, 0x0F, 0x1A)  # 墨玉
GOLD  = (0xC9, 0xA9, 0x6E)  # 古金
GOLD_HI = (0xE4, 0xCA, 0x96)
GOLD_LO = (0x9C, 0x7C, 0x45)
IVORY = (0xF0, 0xEB, 0xE1)  # 象牙白


def catmull_rom(points, t):
    """在控制点序列上做 Catmull-Rom 插值，t ∈ [0,1]。"""
    n = len(points) - 1
    seg = min(int(t * n), n - 1)
    lt = t * n - seg
    p0 = points[max(seg - 1, 0)]
    p1 = points[seg]
    p2 = points[seg + 1]
    p3 = points[min(seg + 2, n)]
    return 0.5 * (
        2 * p1
        + (-p0 + p2) * lt
        + (2 * p0 - 5 * p1 + 4 * p2 - p3) * lt * lt
        + (-p0 + 3 * p1 - 3 * p2 + p3) * lt * lt * lt
    )


# 梅瓶轮廓（半径 / 画布宽）：小口、短颈、丰肩、收胫、微撇足
PROFILE = [0.082, 0.090, 0.068, 0.086, 0.168, 0.222, 0.228, 0.212,
           0.172, 0.138, 0.118, 0.110, 0.124, 0.130]


def lerp(a, b, t):
    return tuple(round(x + (y - x) * t) for x, y in zip(a, b))


img = Image.new("RGB", (W, W), INK)
d = ImageDraw.Draw(img)

cx = W // 2
vase_top = int(W * 0.155)
vase_bot = int(W * 0.870)
vase_h = vase_bot - vase_top
r_scale = W

# 背后的一道古金细环，呼应瓷盘
ring_r = int(W * 0.355)
d.ellipse(
    [cx - ring_r, int(W * 0.5) - ring_r, cx + ring_r, int(W * 0.5) + ring_r],
    outline=lerp(INK, GOLD, 0.22), width=int(W * 0.005),
)

# 瓶身：逐行扫描填充，纵向渐变
for y in range(vase_top, vase_bot):
    t = (y - vase_top) / vase_h
    r = catmull_rom(PROFILE, t) * r_scale
    color = lerp(GOLD_HI, GOLD_LO, t)
    d.rectangle([cx - r, y, cx + r, y + 1], fill=color)

# 左侧一道象牙白高光，暗示釉面
for y in range(vase_top, vase_bot):
    t = (y - vase_top) / vase_h
    r = catmull_rom(PROFILE, t) * r_scale
    if r < W * 0.02:
        continue
    hx = cx - r * 0.46
    hw = max(r * 0.055, 1)
    fade = min(1.0, max(0.0, (t - 0.22) / 0.20)) * min(1.0, max(0.0, (0.88 - t) / 0.28))
    if fade <= 0:
        continue
    d.rectangle([hx - hw, y, hx + hw, y + 1], fill=lerp(GOLD_HI, IVORY, 0.60 * fade))

img = img.filter(ImageFilter.GaussianBlur(SS * 0.35))
img = img.resize((S, S), Image.LANCZOS)
assert img.mode == "RGB", "App Store 不接受带 alpha 通道的图标"

out = "CiJian/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
img.save(out, "PNG")
print(f"{out}  {img.size}  mode={img.mode}")
