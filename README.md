# ram_systemverilog
Реализация простого модуля кэшируемой памяти (CachedRAM) с параметрами ширины данных (DATA_WIDTH) и ширины адреса (ADDR_WIDTH). Кэш состоит из набора строк (cache lines), каждая из которых содержит несколько слов. Кэширование сделано на основе прямого отображения (direct mapped cache) (самый простой способ. Могу расписать подробнее).

**Работа самого модуля:**
В случае сброса (reset) все состояния модуля устанавливаются в начальные значения.
При каждом положительном фронте тактового сигнала модуль выполняет следующие действия:
  - Если произошло попадание в кэш (cacheHit), то данные считываются из кэша и передаются на выход (dataOut).
  - Если не произошло попадание в кэш и включена запись (writeEnable), то происходит обновление кэша: данные из входного сигнала (dataIn) записываются в кэш по адресу(addr), а также обновляются соответствующие тег и флаг валидности.
  - При каждом изменении сигнала (writeEnable) модуль обновляет соответствующий флаг записи в кэш.
