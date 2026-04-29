# 校园Pro - 设计系统指南

## 1. 创意北极星：数字策展人

本设计系统融合"空灵校园"与"时间币"的设计理念，打造一个高端、温暖、具有艺术感的校园社区应用。

**视觉愿景**：通过薄荷绿的清新与琥珀金的温暖，创造既专业又充满活力的校园体验。

---

## 2. 色彩系统

### 核心色标
- **Primary（薄荷绿）**: `#006c53` / **Primary Container**: `#8ff6d0`
- **Secondary（柔和蓝）**: `#3b6095` / **Secondary Container**: `#d5e3ff`
- **Tertiary（琥珀金）**: `#795900` / **Tertiary Container**: `#ffbf00`

### 表面色阶
- **Surface**: `#f8fafb`
- **Surface Container Low**: `#f0f4f6`
- **Surface Container High**: `#e3e9eb`
- **Surface Container Highest**: `#dce4e6`
- **Surface Container Lowest**: `#ffffff`

### 文字颜色
- **On Primary**: `#e5fff2`
- **On Secondary**: `#f8f8ff`
- **On Tertiary**: `#ffffff`
- **On Surface**: `#2c3436`
- **On Surface Variant**: `#596063`
- **Outline Variant**: `#acb3b6`

---

## 3. 设计准则

### 无线化原则（The No-Line Rule）
**禁止使用 1px 实线分割**，通过以下方式定义边界：
- 色块位移：在 Surface 背景上放置 Surface Container Low 的卡片
- 阴影暗示：使用环境光阴影（Ambient Shadow）

### 玻璃态效果（Glassmorphism）
- 浮动导航、顶部栏使用 `backdrop-blur: 20px`
- 透明度：60% - 80%
- 微妙渐变：按钮使用 Primary 到 Primary Container 的线性渐变

### 环境阴影（Ambient Shadows）
- Blur: 30px - 60px
- Opacity: 4% - 8%
- 颜色：使用 On Surface 色调，严禁纯黑

---

## 4. 字体系统

- **Display（Plus Jakarta Sans）**: `display-lg` (3.5rem) - 重大数字、余额展示
- **Headline（Plus Jakarta Sans）**: `headline-md` (1.75rem) - 页面标题
- **Title（Plus Jakarta Sans）**: `title-lg` (1.375rem) - 卡片标题
- **Body（Manrope）**: `body-md` (0.875rem) - 正文内容
- **Label（Manrope）**: `label-sm` (0.6875rem) - 辅助标签

**排版准则**：
- Headline 字母间距：-0.02em
- Body 行高：1.6
- 增加留白，保持呼吸感

---

## 5. 组件使用原则

### 通用 UI 组件优先
- 按钮：优先使用 `@/components/ui/button`
- 输入框：优先使用 `@/components/ui/input`
- 卡片：优先使用 `@/components/ui/card`
- Tabs：优先使用 `@/components/ui/tabs`
- Dialog：优先使用 `@/components/ui/dialog`
- Toast：优先使用 `@/components/ui/toast`

**禁止**：用 View/Text 手搓通用 UI 组件

### 按钮样式
- **Primary**: Primary Container 背景，全圆角，On Primary Container 文字
- **Secondary**: Surface Container High 背景，On Surface 文字
- **Tertiary**: 无背景，Primary 文字

### 卡片样式
- 圆角：`rounded-xl` (1rem) 或 `rounded-2xl` (2rem)
- 背景：Surface Container Lowest
- 无边框，使用幽灵边框（Outline Variant 10-20%）
- 无分割线，通过间距区分内容

### 输入字段
- 背景：Surface Container Low
- 圆角：full 或 2xl
- 无边框
- 占位符：On Surface Variant

---

## 6. 间距系统

- **页面边距**: `px-6` (24px)
- **卡片内边距**: `p-4` (16px) 或 `p-6` (24px)
- **垂直间距**: `gap-4` (16px)
- **模块间距**: `mb-8` (32px) 或 `mb-12` (48px)
- **列表项间距**: `mb-4` (16px) 或 `mb-6` (24px)

---

## 7. 导航结构

### TabBar 配置
- **首页**: `grid_view` 图标
- **广场**: `emoji_events` 或 `explore` 图标
- **个人**: `person` 图标

### 颜色方案
- **未选中**: On Surface Variant (#596063)
- **选中**: Primary (#006c53)
- **背景**: Surface (60% 透明度 + backdrop-blur)

---

## 8. 圆角规范

- **卡片**: `rounded-xl` (1rem) 或 `rounded-2xl` (2rem)
- **按钮**: `rounded-full` (9999px)
- **输入框**: `rounded-full` 或 `rounded-2xl`
- **图片**: `rounded-lg` (0.5rem) 或 `rounded-xl` (1rem)

---

## 9. 执行准则

### ✅ 推荐做法
- 大量留白，保持页面呼吸感
- 使用非对称布局，打破模板感
- 玻璃态导航栏和悬浮元素
- 平滑动画：`cubic-bezier(0.4, 0, 0.2, 1)`

### ❌ 严禁行为
- 严禁 1px 实线分割
- 严禁高对比度边框
- 严禁纯黑文字（使用 On Surface）
- 严禁文字堆砌，精简信息
