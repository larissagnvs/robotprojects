*** Settings ***
Documentation    Suíte de teste para validar fluxo de compra no e-commerce
Library          SeleniumLibrary
Library    Collections
Library    OperatingSystem

Suite Setup        Abrir navegador
Suite Teardown     Fechar navegador


*** Test Cases ***

Cenário I: Logar no e-commerce
    [Documentation]    Este teste visa efetuar login no e-commerce saucedemo.com
    [Tags]             login_ecommerce
    Acessar o site saucedemo.com
    Conferir título Swag Labs na página
    Efetuar login
    Conferir título Products

Cenário II: Adicionar Backpack e Bike no carrinho
    [Documentation]    Este teste irá adicionar produtos ao carrinho
    [Tags]             adicionar_produtos
    Buscar por Backpack
    Adicionar Backpack ao carrinho
    Buscar por Bike
    Adicionar Bike ao carrinho
    Conferir se os dois produtos estão no carrinho

Cenário III: Remover um produto
    [Documentation]    Este teste irá remover um dos produtos do carrinho
    [Tags]             remover_produto
    Buscar por Backpack
    Remover produto do carrinho

Cenário IV: Efetuar compra
    [Documentation]    Este teste irá concluir a compra
    [Tags]             concluir_compra
    Buscar por Bike
    Realizar Checkout
    Inserir dados pessoais
    Buscar por Bike
    Finalizar compra
    Conferir de compra foi efetuada

Cenário V: Efetuar Logoff
    [Documentation]    Este teste irá efetuar logoff do e-commerce
    [Tags]    logoff
    Retornar para a home do site
    Efetuar logoff

*** Variables ***

${browser}        chrome
${url}            https://www.saucedemo.com/



*** Keywords ***

Abrir navegador
    Open Browser    browser=${browser}
    Maximize Browser Window


Fechar navegador
    Close Browser



### Cenário I ###

Acessar o site saucedemo.com
    Go To    url=${url}

Conferir título Swag Labs na página
    Wait Until Element Is Visible    locator=//div[contains(@class,'logo')]

Efetuar login
    Input Text    locator=user-name    text=standard_user
    Input Password    locator=password    password=secret_sauce
    Click Button    locator=login-button

Conferir título Products
    Wait Until Element Is Visible    locator=//span[@class='title'][contains(.,'Products')]


### Cenário II ###

Buscar por Backpack
    Page Should Contain    text=Sauce Labs Backpack

Adicionar Backpack ao carrinho
    Click Button    locator=add-to-cart-sauce-labs-backpack

Buscar por Bike
    Page Should Contain    text=Sauce Labs Bike Light

Adicionar Bike ao carrinho
    Click Button    locator=add-to-cart-sauce-labs-bike-light

Conferir se os dois produtos estão no carrinho
    Click Element    locator=//a[contains(@class,'link')]
    Wait Until Element Is Visible    locator=//span[contains(.,'Your Cart')]
    Page Should Contain Element    locator=//div[@class='inventory_item_name'][contains(.,'Sauce Labs Backpack')]    locator=//div[@class='inventory_item_name'][contains(.,'Sauce Labs Bike Light')]


### Cenário III ###

Remover produto do carrinho
    Click Button    locator=remove-sauce-labs-backpack


### Cenário IV ###

Realizar Checkout
    Click Button    locator=checkout
    Wait Until Element Is Visible    locator=//span[contains(.,'Checkout: Your Information')]

Inserir dados pessoais
    Input Text    locator=first-name    text=Nazaré
    Input Text    locator=last-name    text=Tedesco
    Input Text    locator=postal-code    text=44190-000
    Click Button    locator=continue
    Wait Until Element Is Visible    locator=//span[contains(.,'Checkout: Overview')]

Finalizar compra
    Click Button    locator=finish
    Wait Until Element Is Visible    locator=//span[contains(.,'Checkout: Complete!')]

Conferir de compra foi efetuada
    Page Should Contain    text=Thank you for your order!


### Cenário V ###

Retornar para a home do site
    Click Button    locator=back-to-products
    Conferir título Products

Efetuar logoff
    Click Button    locator=react-burger-menu-btn
    Wait Until Element Is Visible    locator=//a[contains(.,'Logout')]
    Click Element    locator=logout_sidebar_link
    Conferir título Swag Labs na página
