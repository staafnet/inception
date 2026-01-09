all: # Główny target - pełne uruchomienie projektu
	@mkdir -p /home/rgrochow/data/wordpress /home/rgrochow/data/mariadb # Tworzy katalogi dla wolumenów
	@chmod -R 777 /home/rgrochow/data # Nadaje pełne uprawnienia rekursywnie
	docker compose -f srcs/docker-compose.yml up -d --build # Buduje i uruchamia kontenery w tle

up: # Uruchamia kontenery bez rebuildu
	docker compose -f srcs/docker-compose.yml up -d # Startuje istniejące kontenery

down: # Zatrzymuje kontenery
	docker compose -f srcs/docker-compose.yml down # Wyłącza i usuwa kontenery

fclean: # Całkowite czyszczenie - usuwa wszystko
	@docker stop $$(docker ps -qa) 2>/dev/null || true # Zatrzymuje wszystkie kontenery
	@docker rm $$(docker ps -qa) 2>/dev/null || true # Usuwa wszystkie kontenery
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true # Usuwa wszystkie obrazy
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true # Usuwa wszystkie wolumeny
	@docker network rm $$(docker network ls -q) 2>/dev/null || true # Usuwa wszystkie sieci
	@docker system prune -af --volumes 2>/dev/null || true # Prune systemu (cache, unused)
	@sudo rm -rf /home/rgrochow/data 2>/dev/null || true # Usuwa dane (sudo bo pliki należą do kontenerów)
	@printf "Full clean complete!\n" # Informacja o zakończeniu

re: fclean all # Restart - czyści i buduje od nowa

logs: # Pokazuje logi kontenerów na żywo
	docker compose -f srcs/docker-compose.yml logs -f # Follow logs (Ctrl+C aby wyjść)

ps: # Pokazuje status kontenerów
	docker compose -f srcs/docker-compose.yml ps # Lista działających kontenerów

.PHONY: all up down  fclean re logs ps # Deklaruje że to nie są pliki tylko komendy