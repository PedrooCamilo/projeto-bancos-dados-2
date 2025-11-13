# SOLUCAO RAPIDA - Porta 3306 em Uso

## Problema
```
Error response from daemon: Bind for 0.0.0.0:3306 failed: port is already allocated
```

Isso significa que voce tem um MySQL rodando localmente na porta 3306.

## SOLUCAO 1: Parar o MySQL Local (RECOMENDADO)

### Windows (via Servicos):
1. Pressione `Win + R`
2. Digite: `services.msc`
3. Pressione Enter
4. Procure por "MySQL" ou "MySQL80"
5. Clique com botao direito > Parar

### Windows (via PowerShell como Administrador):
```powershell
Stop-Service MySQL80
# ou
Stop-Service MySQL
```

### Depois execute novamente:
```powershell
cd Docker
docker-compose down
docker-compose up --build
```

---

## SOLUCAO 2: Usar Porta Diferente no Docker

### Se voce precisa manter o MySQL local rodando:

1. Edite o arquivo: `Docker\docker-compose.yml`

2. Encontre a linha (aproximadamente linha 30):
```yaml
    ports:
      - "3306:3306"
```

3. Mude para:
```yaml
    ports:
      - "3307:3306"
```

4. Salve o arquivo

5. Execute:
```powershell
cd Docker
docker-compose down
docker-compose up --build
```

6. Agora conecte usando porta **3307** ao inves de 3306:
```
Host: localhost
Port: 3307  <-- MUDOU AQUI
Database: movies_db
User: app_user
Password: app_password
```

---

## VERIFICAR SE A PORTA ESTA LIVRE

Para verificar o que esta usando a porta 3306:

```powershell
netstat -ano | findstr :3306
```

Isso mostrara o PID (Process ID) do programa.

Para ver qual programa e:
```powershell
tasklist | findstr <PID>
```

---

## RECOMENDACAO

Use a **SOLUCAO 1** (parar MySQL local) para evitar confusao.

O projeto foi feito para rodar no Docker, entao o MySQL local nao e necessario.
