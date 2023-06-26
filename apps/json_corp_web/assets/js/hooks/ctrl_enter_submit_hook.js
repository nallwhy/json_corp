export default CtrlEnterSubmitHook = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      if ((e.ctrlkey || e.metaKey) && e.key === "Enter") {
        this.el.form.dispatchEvent(new Event("submit", {bubbles: true, cancelable: true}))
      }
    })
  }
}
