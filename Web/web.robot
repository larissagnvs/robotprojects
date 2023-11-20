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
    Acessar saucedemo.com
    Conferir título Swag Labs
    Efetuar login
    Conferir título Products

Cenário II: Adicionar Backpack e Bike no carrinho
    [Documentation]    Este teste irá adicionar produtos ao carrinho
    [Tags]             adicionar_produtos
    Buscar por Backpack
    Adicionar Backpack no carrinho
    Buscar por Bike
    Adicionar Bike no carrinho
    Conferir os dois produtos no carrinho

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
    Conferir compra efetuada

Cenário V: Efetuar Logoff
    [Documentation]    Este teste irá efetuar logoff do e-commerce
    [Tags]    logoff
    Retornar para a home
    Efetuar logout

*** Variables ***

${browser}             chrome
${url}                 https://www.saucedemo.com/
${cart}                //a[contains(@class,'link')]
${backpack}            //div[@class='inventory_item_name'][contains(.,'Sauce Labs Backpack')]
${bike}                //div[@class='inventory_item_name'][contains(.,'Sauce Labs Bike Light')]
${information}         //span[contains(.,'Checkout: Your Information')]
${overview}            //span[contains(.,'Checkout: Overview')]
${checkoutComplete}    //span[contains(.,'Checkout: Complete!')]
${logout}              //a[contains(.,'Logout')]


*** Keywords ***

Abrir navegador
    Open Browser    browser=${browser}
    Maximize Browser Window


Fechar navegador
    Close Browser



### Cenário I ###

Acessar saucedemo.com
    Go To    url=${url}

Conferir título Swag Labs
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

Adicionar Backpack no carrinho
    Click Button    locator=add-to-cart-sauce-labs-backpack

Buscar por Bike
    Page Should Contain    text=Sauce Labs Bike Light

Adicionar Bike no carrinho
    Click Button    locator=add-to-cart-sauce-labs-bike-light

Conferir os dois produtos no carrinho
    Click Element                    locator=${cart}
    Wait Until Element Is Visible    locator=//span[contains(.,'Your Cart')]
    Page Should Contain Element      locator=${backpack}    locator=${bike}


### Cenário III ###

Remover produto do carrinho
    Click Button    locator=remove-sauce-labs-backpack


### Cenário IV ###

Realizar Checkout
    Click Button    locator=checkout
    Wait Until Element Is Visible    locator=${information}

Inserir dados pessoais
    Input Text    locator=first-name    text=Nazaré
    Input Text    locator=last-name    text=Tedesco
    Input Text    locator=postal-code    text=44190-000
    Click Button    locator=continue
    Wait Until Element Is Visible    locator=${overview}

Finalizar compra
    Click Button    locator=finish
    Wait Until Element Is Visible    locator=${checkoutComplete}


Conferir compra efetuada
    Page Should Contain    text=Thank you for your order!


### Cenário V ###

Retornar para a home
    Click Button    locator=back-to-products
    Conferir título Products

Efetuar logout
    Click Button    locator=react-burger-menu-btn
    Wait Until Element Is Visible    locator=${logout}
    Click Element    locator=logout_sidebar_link
    Conferir título Swag Labs
