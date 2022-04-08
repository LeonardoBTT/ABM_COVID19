cd "Importancia da testagem"
start cmd /k gama-headless.bat impor_testagem_25.xml simulacoes/impor_testagem_25
timeout /t 300
start cmd /k gama-headless.bat impor_testagem_50.xml simulacoes/impor_testagem_50
timeout /t 300
start cmd /k gama-headless.bat impor_testagem_75.xml simulacoes/impor_testagem_75
timeout /t 300
start cmd /k gama-headless.bat impor_testagem_100.xml simulacoes/impor_testagem_100
timeout /t 300

cd '../Importancia das diferentes vacinas'

start cmd /k gama-headless.bat dif_vacinas_5038.xml simulacoes/dif_vacinas_5038 
timeout /t 300
start cmd /k gama-headless.bat dif_vacinas_7040.xml simulacoes/dif_vacinas_7040 
timeout /t 300
start cmd /k gama-headless.bat dif_vacinas_9140.xml simulacoes/dif_vacinas_9140
timeout /t 300
start cmd /k gama-headless.bat dif_vacinas_9450.xml simulacoes/dif_vacinas_9450 
timeout /t 300
start cmd /k gama-headless.bat dif_vacinas_9500.xml simulacoes/dif_vacinas_9500 
timeout /t 300

cd '../Importancia das vacinas'

start cmd /k gama-headless.bat impor_vacinas_25.xml simulacoes/impor_vacinas_25 
timeout /t 300
start cmd /k gama-headless.bat impor_vacinas_50.xml simulacoes/impor_vacinas_50 
timeout /t 300
start cmd /k gama-headless.bat impor_vacinas_75.xml simulacoes/impor_vacinas_75 
timeout /t 300
start cmd /k gama-headless.bat impor_vacinas_100.xml simulacoes/impor_vacinas_100 
timeout /t 300

cd '../Importancia de respeitar as normas sanitarias'

start cmd /k gama-headless.bat impor_normas_25.xml simulacoes/impor_normas_25
timeout /t 300
start cmd /k gama-headless.bat impor_normas_50.xml simulacoes/impor_normas_50 
timeout /t 300
start cmd /k gama-headless.bat impor_normas_75.xml simulacoes/impor_normas_75
timeout /t 300
start cmd /k gama-headless.bat impor_normas_100.xml simulacoes/impor_normas_100 
timeout /t 300

cd '../Importancia de respeitar as normas sanitarias após um evento inesperado'

start cmd /k gama-headless.bat apos_evento_25.xml simulacoes/apos_evento_25
timeout /t 300
start cmd /k gama-headless.bat apos_evento_50.xml simulacoes/apos_evento_50
timeout /t 300
start cmd /k gama-headless.bat apos_evento_75.xml simulacoes/apos_evento_75
timeout /t 300
start cmd /k gama-headless.bat apos_evento_100.xml simulacoes/apos_evento_100
timeout /t 300