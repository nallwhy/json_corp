export default CursorHook = {
  mounted() {
    document.addEventListener('mousemove', (e) => {
      const base_el = document.querySelector('#cursor-live')
      const base_x = base_el.offsetLeft
      const base_y = base_el.offsetTop

      const x = e.pageX - base_x
      const y = e.pageY - base_y

      this.pushEvent('cursor-move', { x, y, base_x, base_y })
    })
  }
}
