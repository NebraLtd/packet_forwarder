# Builds lora_pkt_fwd for each SPI bus and copies each to
# $OUTPUT_DIR/ respectively.

FROM balenalib/rockpi-4b-rk3399-debian:buster-build as lora-pkt-fwd-sx1301-builder

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
COPY --from=nebraltd/lora_gateway:0b0ba3337f98d641cd27d64749bf6f2cbfc962d0 "$LORA_GATEWAY_OUTPUT_DIR" "$LORA_GATEWAY_INPUT_DIR"

# Compile lora_pkt_fwd for all buses
RUN . "$PACKET_FORWARDER_INPUT_DIR/compile_lora_pkt_fwd.sh"
