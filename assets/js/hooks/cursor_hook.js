function throttle(func, time_ms) {
  let throttling = null

  return (...args) => {
    if (throttling === null) {
      func(...args)
      throttling = setTimeout(() => { throttling = null }, time_ms)
    }
  };
}

export default CursorHook = {
  mounted() {
    mousemove_callback = (e) => {
      const base_el = document.querySelector('#cursor-live')
      const base_x = base_el.offsetLeft
      const base_y = base_el.offsetTop

      const x = e.pageX - base_x
      const y = e.pageY - base_y

      this.pushEvent('cursor-move', { x, y, base_x, base_y })
    }

    document.addEventListener('mousemove', throttle(mousemove_callback, 10))
  }
}
