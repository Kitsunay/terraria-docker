FROM mono:slim

# Update and install needed utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget tmux unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# fix for favorites.json error
RUN favorites_path="/root/My Games/Terraria" && mkdir -p "$favorites_path" && echo "{}" > "$favorites_path/favorites.json"

# Download and install Vanilla Server
# ENV VANILLA_VERSION=1.4.3

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-143.zip -O terraria-server.zip && \
    unzip -q terraria-server.zip && \
    mv */Linux /terraria-server && \
    mv */Windows/serverconfig.txt /terraria-server/serverconfig-default.txt && \
    rm -R /tmp/* && \
    chmod +x /terraria-server/TerrariaServer* && \
    if [ ! -f /terraria-server/TerrariaServer ]; then echo "Missing /terraria-server/TerrariaServer"; exit 1; fi

COPY run-vanilla.sh /terraria-server/run.sh

# Allow for external data
VOLUME ["/config"]

# Run the server
WORKDIR /terraria-server
ENTRYPOINT ["./run.sh"]
