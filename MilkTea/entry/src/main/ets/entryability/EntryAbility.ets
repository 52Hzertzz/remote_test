// EntryAbility 应用入口Ability文件
// 作用：应用生命周期管理，窗口创建、页面加载、前后台切换、销毁等系统回调处理
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

// 日志域标识，用于区分应用日志
const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  /**
   * 应用创建生命周期回调
   * @param want 启动携带参数
   * @param launchParam 启动参数
   */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      // 设置应用跟随系统深浅色模式，不强制固定亮色/暗色
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      // 设置颜色模式失败，打印错误日志
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    // 打印应用创建成功日志
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  /**
   * 应用销毁生命周期回调
   */
  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  /**
   * 窗口创建完成回调，加载首页页面
   * @param windowStage 窗口管理实例
   */
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 加载应用首页页面
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        // 页面加载失败打印错误信息
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      // 页面加载成功日志
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  /**
   * 窗口销毁回调，释放UI相关资源
   */
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  /**
   * 应用切换至前台可见状态回调
   */
  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  /**
   * 应用切换至后台不可见状态回调
   */
  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}