#!/bin/bash

echo "================================================="
echo " LIMPEZA TOTAL ABSOLUTA DO LAB EX188 (PODMAN)"
echo "================================================="

### Containers #########################################################
echo ">> Removendo TODOS os containers..."
podman rm -a -f 2>/dev/null || true

### Imagens ############################################################
echo ">> Removendo TODAS as imagens..."
podman rmi -a -f 2>/dev/null || true

### Volumes / Diretórios ##############################################
echo ">> Limpando diretórios de volumes do lab..."
[ -d wp-volume ] && rm -rf wp-volume/*
[ -d databasevolume ] && rm -rf databasevolume/*

### Containerfiles #####################################################
echo ">> Removendo Containerfiles..."
rm -f ex188-server/Containerfile
rm -f ex188-client/Containerfile

### Redes ##############################################################
echo ">> Removendo TODAS as redes customizadas..."
for net in compose_ex188-network-ex7 ex188-network ex188-network-ex7 wp-network; do
  podman network rm "$net" 2>/dev/null || true
done

### Pods ###############################################################
echo ">> Removendo TODOS os pods..."
podman pod rm -a -f 2>/dev/null || true

### Limpeza extra (dangling) ##########################################
echo ">> Limpando recursos órfãos..."
podman system prune -a -f 2>/dev/null || true

echo "================================================="
echo " LIMPEZA CONCLUÍDA — PODMAN 100% LIMPO"
echo "================================================="

