====================================================================
 BACKUP DIARIO AUTOMATICO - RAIO-X (ROBOCOPY)
====================================================================

Script batch (.bat) que faz backup automático de uma pasta de rede
para um HD/pasta de backup, usando o utilitário nativo do Windows
ROBOCOPY. Roda todo dia sozinho, agendado pelo Agendador de Tarefas
do Windows (Task Scheduler) — sem precisar de intervenção manual.

Arquivo: backuprx.bat

--------------------------------------------------------------------
 O QUE O SCRIPT FAZ
--------------------------------------------------------------------

1. Copia todo o conteúdo da pasta de origem para a pasta de destino
   usando o ROBOCOPY (Robust File Copy), ferramenta nativa do
   Windows feita justamente para backups e sincronização de pastas.

2. Parâmetros usados no ROBOCOPY:

   /E     -> copia todas as subpastas, INCLUSIVE as vazias
             (garante que a estrutura de pastas fique idêntica
             à da origem, mesmo pastas sem arquivo dentro).

   /Z     -> modo "restartable": se a cópia de um arquivo for
             interrompida no meio (queda de energia, rede caiu,
             etc), o Robocopy consegue continuar de onde parou
             na próxima execução, em vez de copiar tudo de novo.

   /R:3   -> em caso de falha ao copiar um arquivo (ex: arquivo
             em uso, rede instável), tenta novamente até 3 vezes
             antes de desistir daquele arquivo.

   /W:5   -> espera 5 segundos entre cada nova tentativa de cópia
             de um arquivo que falhou.

   /LOG:  -> salva um relatório completo da execução em
             E:\backup_log.txt, sobrescrevendo o log anterior a
             cada execução (mostra o que foi copiado, o que foi
             pulado por já existir/estar igual, e eventuais erros).

3. O Robocopy, por padrão, só copia arquivos NOVOS ou MODIFICADOS
   desde a última execução (compara data de modificação e tamanho).
   Ou seja, mesmo rodando todo dia, ele não recopia tudo do zero —
   só o que mudou —, o que torna os backups diários rápidos depois
   do primeiro.

4. Ao final, exibe "Backup concluido!" e pausa a janela (pause),
   para o caso de o script ser executado manualmente e alguém
   querer ver o resultado antes de fechar.

--------------------------------------------------------------------
 EXECUÇÃO AUTOMÁTICA DIÁRIA (AGENDADOR DE TAREFAS DO WINDOWS)
--------------------------------------------------------------------

Este .bat é chamado automaticamente todos os dias pelo Agendador de
Tarefas do Windows (Task Scheduler), sem necessidade de execução
manual. Configuração típica usada:

  - Disparador: Diariamente, em um horário fixo (ex: fora do
    expediente, quando a pasta de origem não está em uso).
  - Ação: Iniciar um programa -> caminho do backuprx.bat
  - Executar com privilégios mais altos: recomendado, para evitar
    problemas de permissão ao acessar pastas de rede/drives externos.
  - "Executar mesmo se o usuário não estiver conectado": útil se o
    computador ficar ligado sem ninguém logado no horário do backup.

Como o /LOG sobrescreve o backup_log.txt a cada execução, o log
sempre mostra o resultado da ÚLTIMA rodada apenas (não acumula
histórico de dias anteriores). Se quiser manter o histórico de cada
dia, pode-se trocar /LOG: por /LOG+: (o "+" faz o Robocopy ANEXAR ao
arquivo de log em vez de sobrescrever) ou adicionar a data no nome
do arquivo de log.

--------------------------------------------------------------------
 CONFIGURAÇÃO
--------------------------------------------------------------------

Edite as 3 informações direto na linha do robocopy, se necessário:

  Origem  -> "E:\RAIOSXSERVIDOR"
  Destino -> "G:\Backup_RAIOSXSERVIDOR"
  Log     -> E:\backup_log.txt

--------------------------------------------------------------------
 COMO EXECUTAR MANUALMENTE (TESTE)
--------------------------------------------------------------------

  Dê duplo clique em backuprx.bat
  ou
  Rode pelo Prompt de Comando: backuprx.bat

--------------------------------------------------------------------
 OBSERVAÇÕES
--------------------------------------------------------------------

- Os caminhos usados (E:\RAIOSXSERVIDOR, G:\Backup_RAIOSXSERVIDOR)
  são específicos do ambiente onde o script roda e devem ser
  ajustados para o drive/pasta real de cada máquina.
- O Robocopy, por padrão, NÃO apaga na pasta de destino arquivos que
  foram removidos da origem. Ou seja, este backup é cumulativo
  (fica tudo que já foi copiado alguma vez), o que é mais seguro
  contra exclusão acidental. Se quiser espelhar exatamente a
  origem (removendo do backup o que não existe mais na origem),
  seria necessário adicionar o parâmetro /MIR — mas isso deve ser
  usado com cautela, pois PODE apagar arquivos do backup.
- Script pensado para rodar sem supervisão (backup silencioso via
  Agendador de Tarefas), por isso não interrompe a execução
  pedindo confirmação em nenhum momento.

--------------------------------------------------------------------
 TECNOLOGIAS
--------------------------------------------------------------------

- Batch script (.bat) do Windows
- ROBOCOPY - ferramenta nativa do Windows para cópia robusta de
  arquivos e pastas, com suporte a retomada de cópia interrompida
  e geração de log detalhado
- Agendador de Tarefas do Windows (Task Scheduler) para execução
  diária automática
