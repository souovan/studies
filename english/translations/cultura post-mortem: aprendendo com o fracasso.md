# Cultura Post-mortem: Aprendendo com o fracasso

Minha tradução livre do artigo: https://sre.google/sre-book/postmortem-culture/

> The cost of failure is education

Como SREs, nós trabalhamos como sistemas distribuídos, de larga escala e complexos. Nós constantemente melhoramos nossos serviços com novas funcionalidades e as adicionamos aos sistemas. Incidentes e interrupções são inevitáveis dada nossa escala e velocidade de mudança. Quando um incidente ocorre, nós concertamos o problema principal, e os serviços retornam as condições normais de operação. A menos que nós tenhamos algum tipo formalizado de processo de aprendizado com estes incidentes no lugar, eles podem reaparecer _ad infinitum_. Se deixado sem verificação, incidentes podem se multiplicar em complexidade ou mesmo em cascata, sobrecarregando um sistema e suas operações e finalmente impactando nossos usuários.

O conceito de post-mortem é bem conhecido na indústria de tecnologia. Um post-mortem é um registro escrito de um incidente, seu impacto, as ações tomadas para mitiga-lo ou resolve-lo, a(s) causa(s) raíz(es), e as ações de acompanhamento para previnir que o incidente reapareça. Este capítulo descreve os critérios para decidir quando conduzir post-mortems, algumas melhores práticas recomendadas sobre post-mortems, e concelho sobre como cultivar uma cultura post-mortem baseada na experiência que nós ganhamos ao longo dos anos.

# A filosofia de Post-Mortem do Google

Os objetivos principais de escrever um post-mortem são para garantir que o incident esteja documentado, tudo que contribuír para que a(s) causa(s) raíz(es) sejam bem entendidas, e, especialmente, que ações preventiva eficazes sejam postas em prática para reduzir a probabilidade e/ou impacto de recorrência. Uma pesquisa detalhada da análise da causa raíz está além do escopo deste capítulo. Nossos times usam uma variedade de técnicas para análise de causa(s) raíz(es) e escolhem a técnica mais adequada para os serviços deles. Post-Mortem são esperados após qualquer evento indesejável significativo. Escrever um post-mortem não é punição-é uma oportunidade de aprendizado para a companhia inteira. O processo de post-mortem apresenta um custo inerente em termos de tempo ou esforço, então nós consideramos quando escrever um. Times tem alguma flexibilidade interna, mas os gatilhos post-mortem comuns incluem:

* Tempo de inatividade visível ao usuário ou degradação além de um certo limite
* Perda de dado de qualquer tipo
* Intervenção do engenheiro de plantão (liberação de reversão, redirecionamento de tráfego, etc.)
* Um tempo de resolução acima de algum limite
* Uma falha de monitoramento (o que geralmente implica descoberta manual de incidentes)

É importante definir critérios de post-mortem antes que um incidente ocorra para que todo mundo saiba quando um postmortem é necessário. Além desses gatilhos objetivos, qualquer parte interessada pode solicitar um post-mortem de um evento.

Postmortems sem culpa são um princípio da cultura SRE. Para um post-mortem ser realmente sem cula, ele precisa se concentrar em identificar as causas contribuintes para o incidente sem indiciar qualquer indivíduo ou equipe por comportamento ruim ou inadequado. Um post-mortem escrito sem culpa assume que todos os envolvidos em um incidente tiveram boas intenções e fizeram a coisa certa com a informação que tinham. Se prevalecer uma cultura de apontar o dedo e envergonhar indivíduos ou equipes por fazer a coisa "errada", as pessoas não trarão problemas à tona por medo de punição.

Cultura sem culpa nasceu nas indústrias de saúde e aviônicos, onde os erros podem ser fatais. Essas industrias nutrem um ambiente onde cada "erro" é visto como uma oportunidade para fortalecer o sistema. Quando os post-mortem mudam de atribuir culpas para investigar as razões sistemáticas pelas quais um indivíduo ou equipe tinha informações incompletas ou incorretas, planos de prevenção eficazes podem ser implementadas. Você não pode "consertar" as pessoas, mas pode consertar sistemas e processos para apoiar melhor as pessoas que fazem as escolhas certas ao projetar e manter sistemas complexos.

Quando ocorre uma interrupção, um post-mortem não é escrito como uma formalidade a ser esquecida. Em vez disso, um post-mortem é visto pelos engenheiros como uma oportunidade não apenas para corrigir uma fraqueza, mas para tornar o Google mais resiliente como um todo. Embora um post-mortem sem culpa não apenas desabafe a frustração apontando o dedo, ele deve apontar onde e como os serviços podem ser melhorados. Aqui estão dois exemplos:

## Apontando dedos

> "Precisamos reescrever todo o complicado sistema de back-end! Está quebrando semanalmente nos últimos três trimestres e tenho certeza de que estamos todos cansados de consertar as coisas. Sério, se eu for chamado mais uma vez, vou reescrever eu mesmo…"

## Sem culpa

> "Um item de ação para reescrever todo o sistema de back-end pode realmente impedir que essas páginas irritantes continuem a acontecer, e o manual de manutenção para esta versão é bastante longo e muito difícil de ser totalmente treinado. Tenho certeza de que nossos futuros visitantes vão nos agradecer!"

## Melhor prática: evitar a culpa e mantê-la construtiva

Postmortems sem culpa podem ser difíceis de escrever, porque o formato postmortem identifica claramente as ações que levaram ao incidente. Remover a culpa de um post-mortem dá às pessoas a confiança para escalar os problemas sem medo. Também é importante não estigmatizar a produção frequente de post-mortem por uma pessoa ou equipe. Uma atmosfera de culpa corre o risco de criar uma cultura na qual incidentes e problemas são varridos para debaixo do tapete, levando a um risco maior para a organização.

# Colabore e compartilhe conhecimento

Valorizamos a colaboração e o processo post-mortem não é exceção. O fluxo de trabalho post-mortem inclui colaboração e compartilhamento de conhecimento em todas as etapas.

Nossos documentos postmortem são Google Docs, com um modelo interno (veja Exemplo Postmortem). Independentemente da ferramenta específica que você usa, procure os seguintes recursos principais:

Colaboração em tempo real

    Permite a coleta rápida de dados e ideias. Essencial durante a criação inicial de um post-mortem.

Um sistema aberto de comentários/anotações

    Facilita as soluções de crowdsourcing e melhora a cobertura.

Notificações por e-mail

    Pode ser direcionado a colaboradores dentro do documento ou usado para fazer loop em outros para fornecer entrada.

Escrever um post-mortem também envolve revisão formal e publicação. Na prática, as equipes compartilham o primeiro rascunho post-mortem internamente e solicitam a um grupo de engenheiros seniores que avaliem o rascunho quanto à completude. Os critérios de revisão podem incluir:

* Os principais dados de incidentes foram coletados para a posteridade?
* As avaliações de impacto estão completas?
* A causa raiz foi suficientemente profunda?
* O plano de ação é apropriado e as correções de bugs resultantes têm prioridade apropriada?
* Compartilhamos o resultado com as partes interessadas relevantes?

Depois que a revisão inicial é concluída, o post-mortem é compartilhado de forma mais ampla, normalmente com a equipe de engenharia maior ou em uma lista de discussão interna. Nosso objetivo é compartilhar postmortems para o público mais amplo possível que se beneficiaria do conhecimento ou das lições transmitidas. O Google tem regras rígidas sobre o acesso a qualquer informação que possa identificar um usuário final, e até mesmo documentos internos, como post-mortems, nunca incluem essas informações.

# Melhor prática: nenhum post-mortem deixado sem revisão

Um post-mortem não revisado poderia muito bem nunca ter existido. Para garantir que cada rascunho concluído seja revisado, incentivamos sessões regulares de revisão para post-mortem. Nessas reuniões, é importante encerrar quaisquer discussões e comentários em andamento, capturar ideias e finalizar o estado.

Quando os envolvidos estiverem satisfeitos com o documento e seus itens de ação, o post-mortem é adicionado a um repositório de incidentes passados da equipe ou da organização. O compartilhamento transparente torna mais fácil para outros encontrar e aprender com o post-mortem.

# Apresentando uma cultura postmortem

É mais fácil falar do que fazer a introdução de uma cultura post-mortem em sua organização; tal esforço requer cultivo e reforço contínuos. Reforçamos uma cultura pos-mortem colaborativa por meio da participação ativa da alta administração no processo de revisão e colaboração. A administração pode encorajar essa cultura, mas post-mortems irrepreensíveis são, idealmente, o produto da automotivação do engenheiro. No espírito de nutrir a cultura postmortem, os SREs criam proativamente atividades que disseminam o que aprendemos sobre a infraestrutura do sistema. Alguns exemplos de atividades incluem:

Postmortem do mês

    Em um boletim mensal, um post-mortem interessante e bem escrito é compartilhado com toda a organização.

Grupo pós-morte do Google+

    Este grupo compartilha e discute postmortems internos e externos, melhores práticas e comentários sobre postmortems.

Clubes de leitura post mortem

    As equipes organizam regularmente clubes de leitura post-mortem, nos quais um post-mortem interessante ou impactante é trazido à mesa (junto com alguns petiscos saborosos) para um diálogo aberto com participantes, não participantes e novos Googlers sobre o que aconteceu, quais lições o incidente transmitiu e as após o incidente. Muitas vezes, um post-mortem que está sendo revisada tem meses ou anos!

Roda do Infortúnio

    Novos SREs são frequentemente tratados com o exercício Roda do Infortúnio, no qual um post-mortem anterior é reencenada com um elenco de engenheiros desempenhando papéis conforme estabelecido no post-mortem. O comandante do incidente original atende para ajudar a tornar a experiência o mais "real" possível.

Um dos maiores desafios da introdução de postmortems em uma organização é que alguns podem questionar seu valor devido ao custo de sua preparação. As seguintes estratégias podem ajudar a enfrentar esse desafio:

* Facilite postmortems no fluxo de trabalho. Um período de teste com várias autópsias completas e bem-sucedidas pode ajudar a provar seu valor, além de ajudar a identificar quais critérios devem iniciar uma autópsia.
* Certifique-se de que escrever postmortems eficazes seja uma prática recompensada e celebrada, tanto publicamente por meio dos métodos sociais mencionados anteriormente quanto por meio do gerenciamento de desempenho individual e de equipe.
* Incentive o reconhecimento e a participação da liderança sênior. Até Larry Page fala sobre o alto valor dos post-mortem!

## Melhor prática: recompensar visivelmente as pessoas por fazerem a coisa certa

Os fundadores do Google, Larry Page e Sergey Brin, apresentam o TGIF, um evento semanal realizado ao vivo em nossa sede em Mountain View, Califórnia, e transmitido para os escritórios do Google em todo o mundo. Um TGIF de 2014 concentrou-se em "The Art of the Postmortem", que apresentou a discussão do SRE sobre incidentes de alto impacto. Um SRE discutiu um lançamento que ele havia feito deploy recentemente; apesar dos testes completos, uma interação inesperada derrubou inadvertidamente um serviço crítico por quatro minutos. O incidente durou apenas quatro minutos porque o SRE teve a presença de espírito de reverter a mudança imediatamente, evitando uma interrupção muito mais longa e em maior escala. Esse engenheiro não apenas recebeu dois bônus de colegas imediatamente em reconhecimento ao tratamento rápido e sensato do incidente, mas também recebeu uma enorme salva de palmas do público da TGIF, que incluía os fundadores da empresa e uma audiência de Googlers aos milhares. Além de um fórum tão visível, o Google tem uma série de redes sociais internas que direcionam elogios de colegas para postmortems bem escritos e tratamento excepcional de incidentes. Este é um exemplo de muitos em que o reconhecimento dessas contribuições vem de colegas, CEOs e todos os demais.

## Melhor prática: peça feedback sobre a eficácia pós-morte

No Google, nos esforçamos para resolver os problemas à medida que eles surgem e compartilhar inovações internamente. Fazemos pesquisas regulares com nossas equipes sobre como o processo post-mortem está apoiando seus objetivos e como o processo pode ser melhorado. Fazemos perguntas como: A cultura está apoiando seu trabalho? Escrever um post-mortem envolve muita labuta. Quais práticas recomendadas sua equipe recomenda para outras equipes? Que tipo de ferramentas você gostaria de ver desenvolvidas? Os resultados da pesquisa dão aos SREs nas trincheiras a oportunidade de pedir melhorias que aumentarão a eficácia da cultura postmortem.

Além dos aspectos operacionais de gerenciamento e acompanhamento de incidentes, a prática pós-morte foi incorporada à cultura do Google: agora é uma norma cultural que qualquer incidente significativo seja seguido por um post-mortem abrangente.

# Conclusão e Melhorias Contínuas

Podemos dizer com confiança que, graças ao nosso investimento contínuo no cultivo de uma cultura postmortem, o Google resiste a menos interrupções e promove uma melhor experiência do usuário. Nosso grupo de trabalho "Postmortems no Google" é um exemplo de nosso compromisso com a cultura de post-mortem sem culpa. Esse grupo coordena os esforços postmortem em toda a empresa: reunindo modelos postmortem, automatizando a criação postmortem com dados de ferramentas usadas durante um incidente e ajudando a automatizar a extração de dados postmortem para que possamos realizar análises de tendências. Conseguimos colaborar em práticas recomendadas de produtos tão díspares como YouTube, Google Fiber, Gmail, Google Cloud, AdWords e Google Maps. Embora esses produtos sejam bastante diversos, todos eles realizam post-mortem com o objetivo universal de aprender com nossas horas mais sombrias.

Com um grande número de postmortems produzidos a cada mês no Google, as ferramentas para agregar postmortems estão se tornando cada vez mais úteis. Essas ferramentas nos ajudam a identificar temas e áreas comuns para melhoria nos limites do produto. Para facilitar a compreensão e a análise automatizada, recentemente aprimoramos nosso modelo postmortem com campos de metadados adicionais. O trabalho futuro neste domínio inclui aprendizado de máquina para ajudar a prever nossas fraquezas, facilitar a investigação de incidentes em tempo real e reduzir incidentes duplicados.







