# Lap Counter
## Team Members
- Dalibor Dřevojánek
- Jakub Chrástek
- Jakub Jureček
- David Ecler

## Theoretical description and explanation
Naším zadáním je časovač s počítáním kol a pauzami mezi nimi. U časovače lze nastavit délku kola, počet kol a délku pauzy mezi koly. Tyto hodnoty v našem řešení reprezentují spínače (switche) na FPGA desce. Po stisknutí tlačítka začne časovač postupně odpočítávat čas kola a po jeho vypršení přejde na odpočet pauzy, po které následuje další kolo. Tento cyklus se opakuje podle počtu nastavených kol.

## Hardware description of demo application
![schema](./img/schema.png)

Implenotovanými komponentami jsou:
- **clk_enable**
  - Odpovědný za generování hodinového signálu pro čítač vteřin
- **cnt_down**
  - odpovědný za odpočítávání času kola a pauzy
- **state_ctrl**
  - odpovědný za řízení stavů časovače
- **time_ctrl**
  - odpovědný za řízení čítače cnt_down
- **data_hold**
  - odpovědný za uchovánvání dat zadaných pomocí spínačů
  - je navržen tak, aby na výstup převáděl pouze hodnoty zadané ve stavu menu
- **display_driver**
  - odpovědný za ovládání 7-segmentových displejů
