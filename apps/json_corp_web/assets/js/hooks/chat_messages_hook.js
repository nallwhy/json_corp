export default ChatMessagesHook = {
  mounted() {
    this.handleEvent("message_sent", () => {
      this.el.scrollTop = this.el.scrollHeight
    })
  }
}
