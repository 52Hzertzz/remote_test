// 应用数据备份恢复扩展Ability
// 功能：系统备份/恢复应用本地数据时触发对应回调
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

// 日志域标识，统一日志分类
const DOMAIN = 0x0000;

export default class EntryBackupAbility extends BackupExtensionAbility {
  /**
   * 系统执行备份时触发
   */
  async onBackup() {
    // 打印备份开始日志
    hilog.info(DOMAIN, 'testTag', 'onBackup ok');
    await Promise.resolve();
  }

  /**
   * 系统执行数据恢复时触发
   * @param bundleVersion 当前应用版本信息
   */
  async onRestore(bundleVersion: BundleVersion) {
    // 打印恢复日志并输出版本信息
    hilog.info(DOMAIN, 'testTag', 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
    await Promise.resolve();
  }
}