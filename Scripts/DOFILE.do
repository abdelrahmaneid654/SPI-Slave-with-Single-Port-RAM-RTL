vlib work
vlog Ram.v SPI.v SPI_Top.v SPI_tb.v
vsim -voptargs=+acc work.SPI_tb

# --- Waveform Configuration ---
add wave -divider "Global Signals"
add wave sim:/SPI_tb/clk
add wave sim:/SPI_tb/rst

add wave -divider "SPI Pins"
add wave sim:/SPI_tb/SS_n
add wave sim:/SPI_tb/MOSI
add wave sim:/SPI_tb/MISO

add wave -divider "RAM Data"
add wave -radix hex sim:/SPI_tb/t/R/MEM
add wave -radix hex sim:/SPI_tb/t/rx_data
add wave -radix hex sim:/SPI_tb/t/tx_data
add wave -radix hex sim:/SPI_tb/t/tx_valid
add wave -radix hex sim:/SPI_tb/t/rx_valid


run -all