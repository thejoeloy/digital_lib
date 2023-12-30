# digital_lib

## simple_cpus
Contains a single cycle, a multi-cycle, and a pipelined implementation of a small subset of the risc-v instruction set as described in the
textbook Computer Organization and Design by Hennesey and Patterson

## rv32i-pipelined processor
Contains a 5 stage pipelined implementation of the RV32I ISA with the exception of the CSR ops, fence ops, and environment ops.

### Resource Utilization
1. Slice Logic<br>
--------------<br>

+-------------------------+------+-------+------------+-----------+-------+<br>
|        Site Type        | Used | Fixed | Prohibited | Available | Util% |<br>
+-------------------------+------+-------+------------+-----------+-------+<br>
| Slice LUTs*             | 1148 |     0 |          0 |     53200 |  2.16 |<br>
|   LUT as Logic          | 1148 |     0 |          0 |     53200 |  2.16 |<br>
|   LUT as Memory         |    0 |     0 |          0 |     17400 |  0.00 |<br>
| Slice Registers         |  305 |     0 |          0 |    106400 |  0.29 |<br>
|   Register as Flip Flop |  305 |     0 |          0 |    106400 |  0.29 |<br>
|   Register as Latch     |    0 |     0 |          0 |    106400 |  0.00 |<br>
| F7 Muxes                |    0 |     0 |          0 |     26600 |  0.00 |<br>
| F8 Muxes                |    0 |     0 |          0 |     13300 |  0.00 |<br>
+-------------------------+------+-------+------------+-----------+-------+<br>
* Warning! The Final LUT count, after physical optimizations and full implementation, is typically lower. Run opt_design after synthesis, if not already completed, for a more realistic count.<br>
Warning! LUT value is adjusted to account for LUT combining.<br>

1.1 Summary of Registers by Type<br>
--------------------------------<br>

+-------+--------------+-------------+--------------+<br>
| Total | Clock Enable | Synchronous | Asynchronous |<br>
+-------+--------------+-------------+--------------+<br>
| 0     |            _ |           - |            - |<br>
| 0     |            _ |           - |          Set |<br>
| 0     |            _ |           - |        Reset |<br>
| 0     |            _ |         Set |            - |<br>
| 0     |            _ |       Reset |            - |<br>
| 0     |          Yes |           - |            - |<br>
| 0     |          Yes |           - |          Set |<br>
| 0     |          Yes |           - |        Reset |<br>
| 0     |          Yes |         Set |            - |<br>
| 305   |          Yes |       Reset |            - |<br>
+-------+--------------+-------------+--------------+<br>

2. Memory<br>
---------<br>

+-------------------+------+-------+------------+-----------+-------+<br>
|     Site Type     | Used | Fixed | Prohibited | Available | Util% |<br>
+-------------------+------+-------+------------+-----------+-------+<br>
| Block RAM Tile    |    2 |     0 |          0 |       140 |  1.43 |<br>
|   RAMB36/FIFO*    |    1 |     0 |          0 |       140 |  0.71 |<br>
|     RAMB36E1 only |    1 |       |            |           |       |<br>
|   RAMB18          |    2 |     0 |          0 |       280 |  0.71 |<br>
|     RAMB18E1 only |    2 |       |            |           |       |<br>
+-------------------+------+-------+------------+-----------+-------+<br>
* Note: Each Block RAM Tile only has one FIFO logic available and therefore can accommodate only one FIFO36E1 or one FIFO18E1. However, if a FIFO18E1 occupies a Block RAM Tile, that tile can still accommodate a RAMB18E1<br>

3. DSP<br>
------<br>

+-----------+------+-------+------------+-----------+-------+<br>
| Site Type | Used | Fixed | Prohibited | Available | Util% |<br>
+-----------+------+-------+------------+-----------+-------+<br>
| DSPs      |    0 |     0 |          0 |       220 |  0.00 |<br>
+-----------+------+-------+------------+-----------+-------+<br>

4. IO and GT Specific<br>
---------------------<br>

+-----------------------------+------+-------+------------+-----------+-------+<br>
|          Site Type          | Used | Fixed | Prohibited | Available | Util% |<br>
+-----------------------------+------+-------+------------+-----------+-------+<br>
| Bonded IOB                  |   10 |     0 |          0 |       200 |  5.00 |<br>
| Bonded IPADs                |    0 |     0 |          0 |         2 |  0.00 |<br>
| Bonded IOPADs               |    0 |     0 |          0 |       130 |  0.00 |<br>
| PHY_CONTROL                 |    0 |     0 |          0 |         4 |  0.00 |<br>
| PHASER_REF                  |    0 |     0 |          0 |         4 |  0.00 |<br>
| OUT_FIFO                    |    0 |     0 |          0 |        16 |  0.00 |<br>
| IN_FIFO                     |    0 |     0 |          0 |        16 |  0.00 |<br>
| IDELAYCTRL                  |    0 |     0 |          0 |         4 |  0.00 |<br>
| IBUFDS                      |    0 |     0 |          0 |       192 |  0.00 |<br>
| PHASER_OUT/PHASER_OUT_PHY   |    0 |     0 |          0 |        16 |  0.00 |<br>
| PHASER_IN/PHASER_IN_PHY     |    0 |     0 |          0 |        16 |  0.00 |<br>
| IDELAYE2/IDELAYE2_FINEDELAY |    0 |     0 |          0 |       200 |  0.00 |<br>
| ILOGIC                      |    0 |     0 |          0 |       200 |  0.00 |<br>
| OLOGIC                      |    0 |     0 |          0 |       200 |  0.00 |<br>
+-----------------------------+------+-------+------------+-----------+-------+<br>

5. Clocking<br>
-----------<br>

+------------+------+-------+------------+-----------+-------+<br>
|  Site Type | Used | Fixed | Prohibited | Available | Util% |<br>
+------------+------+-------+------------+-----------+-------+<br>
| BUFGCTRL   |    1 |     0 |          0 |        32 |  3.13 |<br>
| BUFIO      |    0 |     0 |          0 |        16 |  0.00 |<br>
| MMCME2_ADV |    0 |     0 |          0 |         4 |  0.00 |<br>
| PLLE2_ADV  |    0 |     0 |          0 |         4 |  0.00 |<br>
| BUFMRCE    |    0 |     0 |          0 |         8 |  0.00 |<br>
| BUFHCE     |    0 |     0 |          0 |        72 |  0.00 |<br>
| BUFR       |    0 |     0 |          0 |        16 |  0.00 |<br>
+------------+------+-------+------------+-----------+-------+<br>

6. Specific Feature<br>
-------------------<br>

+-------------+------+-------+------------+-----------+-------+<br>
|  Site Type  | Used | Fixed | Prohibited | Available | Util% |<br>
+-------------+------+-------+------------+-----------+-------+<br>
| BSCANE2     |    0 |     0 |          0 |         4 |  0.00 |<br>
| CAPTUREE2   |    0 |     0 |          0 |         1 |  0.00 |<br>
| DNA_PORT    |    0 |     0 |          0 |         1 |  0.00 |<br>
| EFUSE_USR   |    0 |     0 |          0 |         1 |  0.00 |<br>
| FRAME_ECCE2 |    0 |     0 |          0 |         1 |  0.00 |<br>
| ICAPE2      |    0 |     0 |          0 |         2 |  0.00 |<br>
| STARTUPE2   |    0 |     0 |          0 |         1 |  0.00 |<br>
| XADC        |    0 |     0 |          0 |         1 |  0.00 |<br>
+-------------+------+-------+------------+-----------+-------+<br>

7. Primitives<br>
-------------<br>

+----------+------+---------------------+<br>
| Ref Name | Used | Functional Category |<br>
+----------+------+---------------------+<br>
| LUT6     |  563 |                 LUT |<br>
| FDRE     |  305 |        Flop & Latch |<br>
| LUT5     |  218 |                 LUT |<br>
| LUT4     |  193 |                 LUT |<br>
| LUT2     |  167 |                 LUT |<br>
| LUT1     |  156 |                 LUT |<br>
| LUT3     |  122 |                 LUT |<br>
| CARRY4   |   68 |          CarryLogic |<br>
| OBUF     |    8 |                  IO |<br>
| RAMB18E1 |    2 |        Block Memory |<br>
| IBUF     |    2 |                  IO |<br>
| RAMB36E1 |    1 |        Block Memory |<br>
| BUFG     |    1 |               Clock |<br>
+----------+------+---------------------+<br>

### Timing

Table of Contents<br>
-----------------<br>
1. checking no_clock (0)<br>
2. checking constant_clock (0)<br>
3. checking pulse_width_clock (0)<br>
4. checking unconstrained_internal_endpoints (0)<br>
5. checking no_input_delay (1)<br>
6. checking no_output_delay (8)<br>
7. checking multiple_clock (0)<br>
8. checking generated_clocks (0)<br>
9. checking loops (0)<br>
10. checking partial_input_delay (0)<br>
11. checking partial_output_delay (0)<br>
12. checking latch_loops (0)<br>




## Digital Building Blocks
Contains a variety of fundamental combinational and sequential circuits
