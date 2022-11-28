echo CMD
cd "%BUILD_WORKSPACE_DIRECTORY%"
del /s /q /f "@@TO_DIR@@"
md "@@TO_DIR@@"
xcopy /e "@@FROM_DIR@@" "@@TO_DIR@@"
