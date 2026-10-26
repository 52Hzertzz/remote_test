// login.ets 登录注册页面
import { router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct LoginPage {
  // 输入框绑定
  @Local phoneText: string = ""
  @Local codeText: string = ""
  @Local agreeRule: boolean = false
  // 倒计时状态
  @Local countDownNum: number = 0

  build() {
    Column() {
      // 顶部返回栏
      this.TopBackBar()

      Scroll() {
        Column() {
          // Logo+标题
          this.LogoTitle()
          Blank().height(40)

          // 手机号输入框
          this.InputPhone()
          Blank().height(16)

          // 验证码行
          this.InputCodeRow()
          Blank().height(24)

          // 同意协议勾选
          this.RuleCheckRow()
          Blank().height(30)

          // 登录按钮
          this.LoginBtn()
          Blank().layoutWeight(1)

          // 底部第三方登录
          this.OtherLogin()
        }
        .width("100%")
        .padding({ left: 24, right: 24, top: 20 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width("100%")
    .height("100%")
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  // 返回顶部栏
  @Builder
  TopBackBar() {
    Row() {
      Image($r("app.media.left"))
        .width(24)
        .height(24)
        .onClick(() => router.back())
      Blank()
      Text("登录/注册")
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
      Blank()
      // 占位对齐
      Row().width(24)
    }
    .width("100%")
    .height(48)
    .padding({ left: 16, right: 16 })
  }

  // Logo与标题
  @Builder
  LogoTitle() {
    Column() {
      Image($r("app.media.mollytea"))
        .width(80)
        .height(80)
        .margin({ bottom: 12 })
      Text("茉莉奶白 MOLLYTEA")
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor("#D84A7C")
      Text("登录解锁奶茶会员全部权益")
        .fontSize(13)
        .fontColor("#999")
        .margin({ top: 6 })
    }
    .width("100%")
    .alignItems(HorizontalAlign.Center)
  }

  // 手机号输入框
  @Builder
  InputPhone() {
    Row() {
      TextInput({ placeholder: "+86 请输入手机号" })
        .layoutWeight(1)
        .fontSize(16)
        .maxLength(11)
        .onChange((val: string) => {
          this.phoneText = val
        })
    }
    .width("100%")
    .padding({ bottom: 10 })
    .border({ width: { bottom: 1 }, color: "#eee" })
  }

  // 验证码输入+获取按钮
  @Builder
  InputCodeRow() {
    Row() {
      TextInput({
        placeholder: "请输入验证码",
        text: this.codeText
      })
        .layoutWeight(1)
        .fontSize(16)
        .maxLength(6)
        .type(InputType.Number)  // 设置为数字键盘
        .onChange((val: string) => {
          this.codeText = val
        })

      Blank().width(12)

      Text(this.countDownNum > 0 ? `${this.countDownNum}s` : "获取验证码")
        .fontSize(14)
        .fontColor(this.countDownNum > 0 ? "#999" : "#D84A7C")
        .onClick(() => {
          if (this.countDownNum === 0 && this.phoneText.length === 11) {
            this.countDownNum = 60
            // 模拟倒计时
            let timer = setInterval(() => {
              this.countDownNum--
              if (this.countDownNum <= 0) {
                clearInterval(timer)
              }
            }, 1000)
          }
        })
    }
    .width("100%")
    .padding({ bottom: 10 })
    .border({ width: { bottom: 1 }, color: "#eee" })
  }

  // 同意用户协议勾选
  @Builder
  RuleCheckRow() {
    Row() {
      Image(this.agreeRule ? $r("app.media.checked") : $r("app.media.dot"))
        .width(18)
        .height(18)
        .onClick(() => {
          this.agreeRule = !this.agreeRule
        })
      Text("已阅读并同意")
        .fontSize(12)
        .fontColor("#666")
        .margin({ left: 6 })
      Text("《茉莉奶白用户协议》《隐私政策》")
        .fontSize(12)
        .fontColor("#D84A7C")
    }
    .width("100%")
  }

  // 登录按钮
  @Builder
  LoginBtn() {
    Text("登录 / 注册")
      .width("100%")
      .height(46)
      .textAlign(TextAlign.Center)
      .fontSize(16)
      .fontColor(Color.White)
      .backgroundColor(this.agreeRule && this.phoneText.length === 11 && this.codeText.length === 6 ? "#D84A7C" : "#f0d2dd")
      .borderRadius(23)
      .onClick(() => {
        if (!this.agreeRule) return
        if (this.phoneText.length !== 11) return
        if (this.codeText.length !== 6) return
        // 登录成功，返回会员中心并更新登录状态
        router.back({
          url: "pages/people/people",
          params: {
            loginSuccess: true,
            nickName: "茉莉奶白用户"
          }
        })
      })
  }

  // 底部第三方登录
  @Builder
  OtherLogin() {
    Column() {
      Row() {
        Divider().layoutWeight(1).color("#eee")
        Text("其他登录方式")
          .fontSize(12)
          .fontColor("#999")
          .margin({ left: 10, right: 10 })
        Divider().layoutWeight(1).color("#eee")
      }
      .width("100%")
      .margin({ bottom: 20 })

      Row() {
        Image($r("app.media.weixing"))
          .width(36)
          .height(36)
        Blank().width(40)
        Image($r("app.media.QQ"))
          .width(36)
          .height(36)
      }
      .width("100%")
      .justifyContent(FlexAlign.Center)
    }
    .width("100%")
    .margin({ bottom: 30 })
  }
}