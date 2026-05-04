## EX188 Red Hat Certified Specialist In Containers

> 💡 Dica
> 
> - *Pontuação Máxima:* 300
> - *Nota de Corte / Aprovação:* 210
> - *Duração:* 2½ horas

---

## Instruções Iniciais

### I. Geral

1. No exame, eles fornecerão as credenciais iniciais para login em qualquer dispositivo (Ex: flectra1).
2. Devemos usar essas credenciais durante toda a sessão do exame, a menos que seja explicitamente mencionado que é permitido alterá-las.
3. A maioria das atividades é realizada na máquina base do exame, no diretório especificado.
4. podman e podman-compose estarão disponíveis no exame.

---

## Estrutura das Questões

1. Executando Contêineres Simples
2. Interagindo com os Contêineres
3. Injetando Variáveis em Contêineres
4. Construindo Imagem de Contêiner Customizada
5. Implantação Multi-Contêiner
6. Solução de Problemas em Stack Multi-Contêiner

---

## Questões Detalhadas

---

## 1. Executando Contêineres Simples

A corporação *ACME* deseja demonstrar um microsserviço para seu software utilizando contêineres em suas aplicações.

Como demonstração inicial, o contêiner executado deve usar *nginx*.

---

### Tarefa

1. Use a imagem **docker.io/library/nginx**
2. O contêiner deve se chamar *acme-demo-html*
3. O contêiner deve executar em *modo detached*
4. A porta *80* do contêiner deve ser exposta na porta local *8001*
5. O contêiner deve mapear o arquivo local `/home/tux/workspace/acme-nginx-html/index.html`
    

> 💡 Importante
> 
> 
> Nota: O contêiner serve em /usr/share/nginx/html/index.html
> 

---

### Testando seu trabalho

Após o contêiner ser implantado, ele deve estar disponível na seguinte URL:

*http://localhost:8001*

A resposta inicial deve ser:

*"Hello World Nginx"*

---

> ⚠️ *Aviso*
>
> "O sistema de arquivos mapeado localmente deve refletir no contêiner sem necessidade de reimplantação."

---

### Solução

```bash
podman run -d \
--name acme-demo-html \
-p 8001:80 \
-v /home/student/workspace/acme-nginx-html/index.html:/usr/share/nginx/html/index.html:Z \
podman.io/library/nginx

curl http://localhost:8001
```


---

## 2. Interagindo com os Contêineres

A corporação *ACME* deseja conhecer mais sobre a tecnologia de contêineres e como realizar alterações em um contêiner em execução.

---

### Tarefa

1. Use a imagem **docker.io/library/nginx**
2. O contêiner deve se chamar *acme-demo-nginx*
3. O contêiner deve executar em *modo detached* a partir da linha de comando
4. A porta 80 do contêiner deve ser exposta na porta local *8002*
5. Após o contêiner ser implantado e estar em execução, ele deve copiar o diretório do caminho
    
    /home/tux/workspace/acme-nginx-web/html/
    
    para dentro do contêiner no caminho
    
    /usr/share/nginx/html
    
6. O contêiner deve utilizar o arquivo de configuração disponível no caminho
    
    /home/tux/workspace/acme-nginx-web/conf/nginx.conf,
    
    o arquivo de configuração do contêiner está localizado em
    
    /etc/nginx/conf.d/default.conf
    
7. Após o contêiner estar em execução, execute o comando
    
    nginx -s reload para recarregar o nginx
    

---

> ✅ *Sucesso*
>
> Nota: Seu contêiner deve continuar em execução após a configuração.

---

### Testando seu trabalho

Após o contêiner ser implantado, ele deve estar disponível na seguinte URL:

*http://localhost:8002*

A resposta do contêiner deve refletir o conteúdo do arquivo index.html copiado para ele como:

*"Welcome to ACME"*

---

### Solução

```bash
podman run -d \
--name acme-demo-nginx \
-p 8002:80 \
docker.io/library/nginx

podman cp /home/tux/workspace/acme-nginx-web/html/. acme-demo-nginx:/usr/share/nginx/html/

***Aqui está a pegadinha:***

podman cp /home/tux/workspace/acme-nginx-web/conf/nginx.conf \
  acme-demo-nginx:/etc/nginx/conf.d/default.conf

 📌 Mesmo que o arquivo se chame nginx.conf fora, dentro ele deve virar default.conf.

podman exec acme-demo-nginx nginx -s reload

curl http://localhost:8002
```


---

## 3. Injetando Variáveis em Contêineres

---

### Tarefa

1. Use a imagem **quay.io/myacme/welcome**
2. Devem existir dois contêineres chamados
    
    *acme_nginx_container_1* e *acme_nginx_container_2*
    
3. O contêiner *acme_nginx_container_1* deve possuir a variável de ambiente:
    
    RESPONSE=Welcome_ACME_Nginx_Container_1
    
4. O contêiner *acme_nginx_container_2* deve possuir a variável de ambiente:
    
    RESPONSE=Welcome_ACME_Nginx_Container_2
    
5. Os contêineres devem executar em *modo detached*
6. A porta 8080 do contêiner deve ser exposta na porta local *8003*

> 💡 Dica
> 
> Ambos os contêineres devem coexistir, mas não devem estar em execução ao mesmo tempo.

---

### Testando seu trabalho

Após os contêineres serem implantados, eles devem estar disponíveis na seguinte URL:

*http://localhost:8003*

Quando o primeiro contêiner estiver ativo, você deve ver a resposta:

*"Welcome_ACME_Nginx_Container_1"*

Quando o segundo contêiner estiver ativo, você deve ver a resposta:

*"Welcome_ACME_Nginx_Container_2"*

---

### Solução

```bash
podman create  \
--name acme_nginx_container_1 \
-p 8003:8080 \
-e RESPONSE="Welcome_ACME_Nginx_Container_1" \
quay.io/myacme/welcome

podman create  \
--name acme_nginx_container_2 \
-p 8003:8080 \
-e RESPONSE="Welcome_ACME_Nginx_Container_2" \
quay.io/myacme/welcome

podman start acme_nginx_container_1
curl http://localhost:8003
podman stop acme_nginx_container_1

podman start acme_nginx_container_2
curl http://localhost:8003
podman stop acme_nginx_container_2
```


---

## 4. Construindo Imagem de C*ontêiner Customizada

### Tarefa — *acme-db*

1. Construa uma imagem customizada utilizando o arquivo inicial disponível no caminho de referência
    
    /home/tux/workspace/acme-mariadb-containerfile
    
2. A imagem base do contêiner deve ser *mariadb*
3. O Containerfile deve possuir os seguintes *build arguments*:
    - ACME_MARIADB_DATABASE
    - ACME_MARIADB_PASSWORD
4. O contêiner deve possuir as seguintes variáveis de ambiente:
    - MARIADB_DATABASE
    - MARIADB_ROOT_PASSWORD
5. As variáveis de ambiente devem utilizar os build arguments conforme abaixo:
    - MARIADB_DATABASE usa ACME_MARIADB_DATABASE
    - MARIADB_ROOT_PASSWORD usa ACME_MARIADB_PASSWORD
6. Os valores dos build arguments devem ser definidos em tempo de build como:
    - ACME_MARIADB_DATABASE=acme
    - ACME_MARIADB_PASSWORD=acme
7. A imagem deve estar disponível localmente e com a tag
    
    quay.io/sardinhajoaovictor
    
8. Envie a imagem para o registry como
    
    quay.io/sardinhajoaovictor
    

---

### acme-db-exporter

1. Construa uma imagem customizada conforme o requisito abaixo, utilizando o arquivo inicial disponível no caminho de referência
    
    /home/student/workspace/acme-mariadb-db/acme-db-export-containerfile
    
2. A imagem base do contêiner deve ser *mariadb*
3. Copie o arquivo scripts/export.sh para /scripts no contêiner
4. O diretório de trabalho deve ser /scripts
5. Execute o script export.sh
6. A imagem deve estar disponível localmente e com a tag *acme-mariadb-export:latest*
7. Envie a imagem para o registry como
    
    quay.io/sardinhajoaovictor
    

---

### Testando seu trabalho

Execute um contêiner de teste chamado *acme-mariadb-test* usando a imagem disponível em

quay.io/sardinhajoaovictor

O contêiner de teste deve estar em execução após ser inicializado e continuar em execução.

Execute um contêiner de teste chamado *acme-mariadb-exporter* usando a imagem disponível em

quay.io/sardinhajoaovictor, utilizando o mapeamento de caminho local de

/home/student/workspace/acme-mariadb-db/export para /home no contêiner.

Após a execução do contêiner, você deve conseguir ler o arquivo SQL dump localizado em:

/home/student/workspace/acme-mariadb-db/export/acmeMsql.sql

Você deve conseguir ler o dump do MySQL com qualquer leitor.

---

## 5. Stack Multi-Contêiner

Implante uma stack multi-contêiner para *WordPress* com a seguinte especificação:

1. Crie uma rede chamada *acme-wp-net*
2. Crie um volume chamado *acme-wp-backend*
3. Crie outro volume chamado *acme-wp-app*
4. Crie outro volume chamado *acme_wordpress_data*

---

### acme-wp-db

1. Use a imagem **quay.io/myacme/mariadb:latest**
2. O contêiner deve se chamar *mariadb*
3. O contêiner deve fazer parte da rede *acme-wp-net*
4. Mapeie o volume *acme-wp-backend* para /bitnami/mariadb
5. As variáveis de ambiente devem ser:
    - MARIADB_USER=acme_wordpress
    - MARIADB_PASSWORD=acme
    - MARIADB_DATABASE=acme_wordpress
    - MARIADB_ROOT_PASSWORD=acme
6. Exiba o contêiner em execução persistentemente

---

### acme-nginx

1. Use a imagem **quay.io/myacme/nginx**
2. O contêiner deve se chamar *acme-wp-app*
3. Adicione o contêiner à rede *acme-wp-net*
4. Mapeie o caminho /etc/nginx dentro do contêiner
5. A porta 8080 do contêiner deve ser exposta na porta local *8080*

---

### acme-wp-nginx

1. Use a imagem **quay.io/myacme/wordpress:latest**
2. O contêiner deve se chamar *acme-wordpress*
3. Adicione o contêiner à rede *acme-wp-net*
4. Mapeie o volume *acme_wordpress_data* para /bitnami/wordpress
5. A porta 8080 do contêiner deve ser exposta na porta local *8004*
6. A porta 8443 do contêiner deve ser exposta na porta local *8443*
7. As variáveis de ambiente devem ser:
    - WORDPRESS_DATABASE_USER=acme_wordpress
    - WORDPRESS_DATABASE_PASSWORD=acme
    - WORDPRESS_DATABASE_NAME=acme_wordpress
8. Implante o contêiner para executar persistentemente

> 💡 Importante
> 
> Nota: Seu contêiner deve continuar em execução após a configuração.

---

### Testando sua rede

Após o contêiner ser implantado, ele deve estar disponível na seguinte URL:

*https://localhost:8443*

---

## 6. Solução de Problemas em Stack Multi-Contêiner

### Configuração

### Configuração de Rede e Volume

- Crie uma rede chamada *acme-troubleshoot*
- Crie um volume chamado *acme-wp-backend-ts*

---

### Contêiner de Banco de Dados: *acme-wp-db-ts*

- Use a imagem **quay.io/myacme/mariadb:latest**
- Nome do contêiner: *mariadb-ts*
- Conecte o contêiner à rede *acme-troubleshoot*
- (Ignore por enquanto, mas obrigatório no exame)
    
    Mapeie o volume *acme-wp-backend-ts* para /usr/share/mysql dentro do contêiner
    

---

### Contêiner Nginx: *acme-nginx-ts*

- Use a imagem **quay.io/myacme/nginx**
- Nome do contêiner: *acme-nginx-ts*
- Conecte o contêiner à rede *acme-troubleshoot*

---

### Contêiner WordPress: *acme-wp-nginx*

- Nome do contêiner: *acme-wordpress-ts*
- Use a imagem **quay.io/myacme/wordpress:latest**
- Conecte o contêiner à rede *acme-troubleshoot*
- Implante o contêiner para executar persistentemente

---

### Testando seu trabalho

- Após a implantação, verifique se os contêineres estão acessíveis e em execução
- Verifique utilizando:

```bash
podman ps
podman network inspect acme-troubleshoot
podman logs mariadb-ts
podman logs acme-nginx-ts
podman logs acme-wordpress-ts
```
