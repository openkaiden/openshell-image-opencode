#
# Copyright (C) 2026 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# ghcr.io/openkaiden/openshell-image-base-builder:next
FROM ghcr.io/openkaiden/openshell-image-base-builder@sha256:27c5cb3411afcd4950ec89308425d54685a7c07b8de094260e8e92c0c9c9e43e AS builder
ARG OPENCODE_VERSION=2.0.22

# Install opencode and then copy it inside the root filesystem
RUN set -eux; \
    curl -fsSL https://opencode.ai/v2/install | bash -s -- --version "${OPENCODE_VERSION}" --no-modify-path; \
    install -D -m 0755 /root/.opencode/bin/opencode /mnt/rootfs/usr/local/bin/opencode

# Now create our final image with reduced layers
FROM scratch
COPY --from=builder /mnt/rootfs/ /
CMD ["opencode"]
