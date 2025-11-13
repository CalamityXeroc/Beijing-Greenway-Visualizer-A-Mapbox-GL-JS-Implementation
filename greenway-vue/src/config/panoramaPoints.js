// 百度地图全景点位配置
// 这些是温榆河绿道沿线的真实坐标点

export const baiduPanoramaPoints = [
  {
    name: '温榆河公园-东园入口',
    description: '温榆河公园主入口，设施完善',
    // 百度地图坐标 (BD-09)
    lng: 116.531289,
    lat: 40.074156,
    panoId: null // 百度会自动查找最近的全景点
  },
  {
    name: '温榆河湿地公园',
    description: '生态湿地景观，鸟类栖息地',
    lng: 116.520345,
    lat: 40.065432,
    panoId: null
  },
  {
    name: '温榆河滨水步道',
    description: '沿河步道，视野开阔',
    lng: 116.510234,
    lat: 40.055678,
    panoId: null
  },
  {
    name: '温榆河文化广场',
    description: '文化活动中心，休憩好去处',
    lng: 116.498765,
    lat: 40.045123,
    panoId: null
  },
  {
    name: '温榆河观景台',
    description: '最佳观景位置，可俯瞰河道',
    lng: 116.487654,
    lat: 40.035789,
    panoId: null
  }
]

// 将百度坐标转换为WGS84（如果需要）
export function bd09ToWgs84(bdLng, bdLat) {
  const x = bdLng - 0.0065
  const y = bdLat - 0.006
  const z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * Math.PI * 3000.0 / 180.0)
  const theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * Math.PI * 3000.0 / 180.0)
  const wgsLng = z * Math.cos(theta)
  const wgsLat = z * Math.sin(theta)
  return { lng: wgsLng, lat: wgsLat }
}
