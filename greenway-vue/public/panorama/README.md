# 温榆河绿道全景图片说明

## 📸 全景图片要求

### 文件格式
- **格式**: JPG 或 PNG
- **投影方式**: 等距柱状投影 (Equirectangular Projection)
- **推荐分辨率**: 4096 x 2048 像素（或 8192 x 4096 高清版）
- **宽高比**: 2:1

### 如何获取全景图片

#### 方案 1: 使用全景相机拍摄
- **推荐设备**: 
  - Insta360 ONE X2/X3
  - Ricoh Theta Z1
  - GoPro MAX
- **拍摄建议**: 在温榆河绿道沿线选择3-5个有代表性的位置拍摄

#### 方案 2: 使用手机全景模式
- **iOS**: 相机 > 全景模式
- **Android**: 相机 > 更多 > 全景
- **注意**: 手机全景通常是180°，需要使用专业APP拍摄360°

#### 方案 3: 使用免费全景素材
- **网站推荐**:
  - Flickr (搜索 "360 panorama" + "CC license")
  - Pixabay 360° 图片库
  - Pexels 360° 素材

#### 方案 4: 使用示例图片（当前方案）
当前代码使用了 Photo Sphere Viewer 官方提供的示例图片：
- `https://photo-sphere-viewer-data.netlify.app/assets/sphere.jpg`
- `https://photo-sphere-viewer-data.netlify.app/assets/sphere-test.jpg`

## 📁 文件放置位置

将全景图片放置在以下目录中：
```
public/panorama/wenyu/
├── point1.jpg  # 温榆河入口
├── point2.jpg  # 滨水步道
├── point3.jpg  # 观景平台
└── ...
```

## 🔧 更新代码中的图片路径

在 `src/views/WenyuDetail.vue` 中修改 `panoramaPoints` 配置：

```javascript
const panoramaPoints = ref([
  {
    name: '温榆河入口',
    description: '温榆河绿道起点，视野开阔',
    image: '/panorama/wenyu/point1.jpg', // 改为本地路径
    markers: []
  },
  {
    name: '滨水步道',
    description: '沿河步道，两侧绿树成荫',
    image: '/panorama/wenyu/point2.jpg', // 改为本地路径
    markers: []
  },
  {
    name: '观景平台',
    description: '最佳观景位置，可俯瞰河道全景',
    image: '/panorama/wenyu/point3.jpg', // 改为本地路径
    markers: []
  }
])
```

## 🎯 添加热点标记

可以在全景图中添加交互热点：

```javascript
markers: [
  {
    id: 'marker-1',
    position: { yaw: '45deg', pitch: '10deg' }, // 位置（水平角度，垂直角度）
    html: '<div style="color: white; background: rgba(0,0,0,0.7); padding: 5px 10px; border-radius: 4px;">景点名称</div>',
    tooltip: '点击查看详情'
  }
]
```

### 如何确定热点位置
1. 在浏览器中打开全景图
2. 使用开发者工具查看鼠标位置的 yaw 和 pitch 值
3. 将这些值填入 markers 配置中

## 🎨 全景图优化建议

### 图片压缩
使用工具压缩图片以提高加载速度：
- TinyPNG (https://tinypng.com)
- Squoosh (https://squoosh.app)
- ImageOptim (Mac)

### 推荐参数
- **文件大小**: 每张图片控制在 2-5MB
- **质量**: JPEG 质量设置为 80-85%
- **渐进式 JPEG**: 启用渐进式编码

## 📝 示例全景图下载

可以从以下网站下载免费的全景示例图片用于测试：

1. **Pixabay 360**
   - https://pixabay.com/zh/images/search/360/
   - 完全免费，可商用

2. **Flickr 360 Project**
   - https://www.flickr.com/groups/equirectangular/
   - 注意查看许可协议

3. **Poly Haven**
   - https://polyhaven.com/hdris
   - 高质量 HDRI 全景图

## 🚀 功能扩展建议

### 1. 添加小地图定位
显示当前观景点在绿道上的位置

### 2. 添加导航箭头
在全景图中添加方向指示箭头，引导用户到下一个观景点

### 3. 集成音频讲解
为每个观景点添加语音导览

### 4. 添加季节切换
同一位置不同季节的全景对比

### 5. VR 模式优化
添加陀螺仪支持，适配 VR 眼镜

## ❓ 常见问题

**Q: 全景图显示变形怎么办？**
A: 确保图片是 2:1 的等距柱状投影格式

**Q: 如何拍摄高质量全景图？**
A: 使用三脚架固定，避免抖动；选择光线均匀的时间拍摄

**Q: 可以使用视频作为全景源吗？**
A: Photo Sphere Viewer 不直接支持视频，但可以使用视频插件

**Q: 如何优化移动端加载速度？**
A: 使用多分辨率瓦片，根据设备自动加载合适的分辨率
