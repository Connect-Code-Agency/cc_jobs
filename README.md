# CC MRI Jobs Pack - Civil Edition

Pack de empregos civis para servidores MRI/Qbox usando `qbx_core`, `ox_lib`, `ox_target`, `ox_inventory` e `oxmysql`.

## Empregos inclusos

- Correios
- Entregador de Jornal
- Táxi
- Coleta de Lixo
- Transportadora
- Jardinagem
- Companhia Elétrica
- Companhia de Água
- Agricultura
- Pesca Profissional
- Mineradora
- Controle Animal

## Sistemas inclusos

- NPC de atendimento para cada emprego
- Menu com `ox_lib`
- Target com `ox_target`
- Rotas dinâmicas por categoria
- GPS automático até o destino
- Finalização por marcador + tecla E
- Progress bar
- XP por profissão
- Níveis 1 a 10
- Multiplicador de pagamento por nível
- Sequência/streak com bônus
- Ranking TOP 10 por profissão
- Banco SQL próprio
- Configuração centralizada

## Instalação

1. Coloque a pasta `cc_mri_jobs` dentro de `resources/[connect-code]/`.
2. Execute o SQL em `sql/install.sql` no banco do servidor.
3. Adicione os itens de `sql/ox_inventory_items.lua` no `ox_inventory/data/items.lua`.
4. No `server.cfg`, adicione:

```cfg
ensure ox_lib
ensure oxmysql
ensure ox_inventory
ensure ox_target
ensure qbx_core
ensure cc_mri_jobs
```

## Configuração principal

Arquivo: `shared/config.lua`

```lua
Config.RequireJob = false
Config.PaymentAccount = 'cash'
Config.EnableBlips = true
```

- `Config.RequireJob = false`: qualquer jogador pode abrir qualquer emprego.
- `Config.RequireJob = true`: o jogador precisa ter o job do Qbox com o mesmo nome do ID do emprego.

IDs dos empregos:

```txt
correios
jornal
taxi
lixeiro
transportadora
jardinagem
eletrica
agua
agricultura
pesca
mineradora
controleanimal
```

## Como funciona

1. O jogador vai até o NPC do emprego.
2. Abre o menu.
3. Inicia uma rota.
4. Recebe item de serviço quando aplicável.
5. Vai até o destino no GPS.
6. Finaliza o serviço.
7. Recebe dinheiro, XP e progresso.

## Observações importantes

- O script foi feito como base completa e editável.
- Os empregos usam um core genérico; isso deixa o pack leve e fácil de expandir.
- Para um servidor de produção, revise valores de pagamento conforme sua economia.
- Caso seu inventário não tenha item `money`, o pagamento padrão via Qbox será usado quando disponível.

## Personalização

Para mudar NPC, veículo, pagamento, item ou ponto inicial, edite `shared/jobs.lua`.

Exemplo:

```lua
correios = {
    label = 'Correios',
    depot = vec3(78.11, 111.84, 81.17),
    ped = 's_m_m_postal_01',
    vehicle = 'boxville2',
    item = 'delivery_box',
    pay = { min = 150, max = 330 }
}
```

## Próximas melhorias recomendadas

- Spawn/garagem de veículo da empresa
- Uniforme por emprego
- Contratos premium por nível
- UI NUI estilo MRI mais avançada
- Integração com painel administrativo
- Logs via Discord webhook

Feito pore Connect Code.
