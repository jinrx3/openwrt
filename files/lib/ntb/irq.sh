# Functions to balance IRQs across CPUs

balance_irq() {
  _find_irq() {
    local name=$1
    awk -F'[: ]' '/'"$name"'/{print $2}' /proc/interrupts
  }
  _set_affinity() {
    local cpu_mask=$1
    _cpu_iterator() {
      local internal_irq=$1; shift
      _print_irq(){
        printf $(printf '%x' $((1 << $2))) > /proc/irq/$1/smp_affinity
      }
      _print_irq $internal_irq $1; shift
      while read -r irq && [ "x" != "x$1" ]; do
        _print_irq $irq $1; shift
      done
      export irq
    }
    while true; do
      if [ "x" == "x$irq" ]; then
        read -r irq || break
      fi
      _cpu_iterator $irq $(echo "$cpu_mask" | grep -o '.')
    done
  }

  _find_irq bam_dma     | _set_affinity 21
  _find_irq spi         | _set_affinity 3
  _find_irq serial      | _set_affinity 2
  _find_irq ath10k      | _set_affinity 10
  _find_irq edma_eth_tx | _set_affinity 1
  _find_irq edma_eth_rx | _set_affinity 2
  _find_irq keys        | _set_affinity 2
  _find_irq usb         | _set_affinity 2
}
