curl -Ls https://uninstall.tuist.io | bash
brew tap tuist/tuist
brew install --formula tuist@4.43.2

tuist clean && tuist install && tuist generate
