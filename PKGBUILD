# Maintainer: sum117
# Original packaging: Kristoffer Haugland

pkgname=omarchy-activity-monitor-power-helper
pkgver=2.1.1
pkgrel=1
pkgdesc="Optional root-only native RAPL reader for the Omarchy Activity Monitor plugin"
arch=('x86_64')
url="https://github.com/sum117/omarchy-activity-monitor"
license=('MIT')
depends=('gcc-libs' 'glibc' 'sudo')
makedepends=('gcc' 'make')
options=('!debug')
source=(
  'activity-sampler.cpp'
  'Makefile'
  'stappmus-activity-monitor.sudoers'
  'README.md'
  'LICENSE'
)
sha256sums=(
  '37645efc700fa02a6aa6b20ca3435701ca40354384342bf59387fb4ef93cc842'
  '2ea69385047c3a1d1893378e2866a464cba7ae28040c0add8a3eaa80f94700a3'
  'e248f015e89bc7f3df4714e7d1e0248c4ac9cc4b4642dda6aa428741b6c4f2ca'
  '645a0f6bdff1033df4a98098bedfe12232d2b2f4dabc7983d72d41937ce2418a'
  'a166e168420df0ad798aa50509dd9e672b7c6bc2e32b71a2dda784fc5428bda6'
)

build() {
  make activity-sampler
}

check() {
  [[ $(./activity-sampler --version) == 'activity-sampler 2.1.1' ]]
  grep -Fxq \
    '%wheel ALL=(root) NOPASSWD: /usr/lib/stappmus-activity-monitor/activity-sampler --activity-process-power-reader' \
    stappmus-activity-monitor.sudoers
  if command -v visudo >/dev/null 2>&1; then
    visudo -cf stappmus-activity-monitor.sudoers >/dev/null
  fi
}

package() {
  install -Dm755 activity-sampler \
    "$pkgdir/usr/lib/stappmus-activity-monitor/activity-sampler"
  install -Dm440 stappmus-activity-monitor.sudoers \
    "$pkgdir/etc/sudoers.d/stappmus-activity-monitor"
  install -Dm644 README.md \
    "$pkgdir/usr/share/doc/$pkgname/README.md"
  install -Dm644 LICENSE \
    "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
