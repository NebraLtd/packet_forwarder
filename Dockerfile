# Builds lora_pkt_fwd for each SPI bus and copies each to
# $OUTPUT_DIR/ respectively.

ARG BUILD_BOARD

# Pull the correct build of lora_gateway image
ARG BUILD_ARCH
ARG FROM_PATH=nebraltd/lora_gateway:$BUILD_ARCH-9d02824848a85035d63d00820c09d1508a29c29b
FROM $FROM_PATH AS lora_gateway

FROM balenalib/"$BUILD_BOARD"-debian:bullseye-build AS lora-pkt-fwd-sx1301-builder

ENV ROOT_DIR=/opt

# Build output of nebraltd/lora_gateway
ENV LORA_GATEWAY_OUTPUT_DIR=/opt/output

# Intermediary location files from LORA_GATEWAY_OUTPUT_DIR are copied to
ENV LORA_GATEWAY_INPUT_DIR="$ROOT_DIR/lora_gateway_builds"

# Location source files for nebraltd/packet_forwarder are copied to
ENV PACKET_FORWARDER_INPUT_DIR="$ROOT_DIR/packet_forwarder"

# Output built files to this location
ENV OUTPUT_DIR="$ROOT_DIR/output"

WORKDIR "$ROOT_DIR"

# Copy files into expected location
COPY . "$PACKET_FORWARDER_INPUT_DIR"
COPY --from=lora_gateway "$LORA_GATEWAY_OUTPUT_DIR" "$LORA_GATEWAY_INPUT_DIR"

# Compile lora_pkt_fwd for all buses
RUN . "$PACKET_FORWARDER_INPUT_DIR/compile_lora_pkt_fwd.sh"
