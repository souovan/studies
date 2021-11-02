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

WIP.....
