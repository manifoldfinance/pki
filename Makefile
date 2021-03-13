all: ${GITHUB_ORG-ARCHIVE-KEYRING}.gpg ${GITHUB_ORG-SIGNING-KEYRING}.gpg ${ORG}-experimental-keyring.gpg

GPG=gpg --no-default-keyring --no-auto-check-trustdb

# Create the keyrings on the user's system, since the standard
# ascii armoured export format is more stable than keyring files.
${GITHUB_ORG-ARCHIVE-KEYRING}.gpg:
	$(GPG)	--keyring ./${GITHUB_ORG-ARCHIVE-KEYRING}-temp.gpg		\
		--import keys-packaging/${ORG}-deb-packaging-key-*.asc
	$(GPG)	--keyring ./${GITHUB_ORG-ARCHIVE-KEYRING}-temp.gpg		\
		--output $@ --export
	rm ${GITHUB_ORG-ARCHIVE-KEYRING}-temp.gpg ${GITHUB_ORG-ARCHIVE-KEYRING}-temp.gpg~

${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring.gpg:
	$(GPG)	--keyring ./${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring-temp.gpg	\
		--import keys-packaging/${ORG}-EXPERIMENTAL-deb-packaging-key-*.asc
	$(GPG)	--keyring ./${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring-temp.gpg	\
		--output $@ --export
	rm ${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring-temp.gpg			\
		${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring-temp.gpg~

${GITHUB_ORG-SIGNING-KEYRING}.gpg:
	$(GPG)	--keyring ./${GITHUB_ORG-SIGNING-KEYRING}-temp.gpg	\
		--import keys-signing/*.asc
	$(GPG)	--keyring ./${GITHUB_ORG-SIGNING-KEYRING}-temp.gpg	\
		--output $@ --export
	rm ${GITHUB_ORG-SIGNING-KEYRING}-temp.gpg			\
		${GITHUB_ORG-SIGNING-KEYRING}-temp.gpg~

# Don't install the code-signing or experimental keyrings to
# /etc/apt/trusted.gpg.d/
install: ${GITHUB_ORG-ARCHIVE-KEYRING}.gpg ${GITHUB_ORG-SIGNING-KEYRING}.gpg
	install -d $(DESTDIR)/etc/apt/trusted.gpg.d/
	install -d $(DESTDIR)/usr/share/keyrings/
	cp ${GITHUB_ORG-ARCHIVE-KEYRING}.gpg $(DESTDIR)/etc/apt/trusted.gpg.d/
	cp ${GITHUB_ORG-ARCHIVE-KEYRING}.gpg $(DESTDIR)/usr/share/keyrings/
	cp ${GITHUB_ORG-EXPERIMENTAL-KEYRING}-keyring.gpg $(DESTDIR)/usr/share/keyrings/
	cp ${GITHUB_ORG-SIGNING-KEYRING}.gpg $(DESTDIR)/usr/share/keyrings/

clean:
	rm -f ${ORG}-*.gpg ${ORG}-*.gpg~

.PHONY: install clean
