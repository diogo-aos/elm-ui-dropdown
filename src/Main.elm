
module Main exposing (main)

import Browser
import Html

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events

type alias Model =
    { favoriteFood : Dropdown Food
--    , favoriteCar : Dropdown Car
    }

type Dropdown a
    = Normal (Maybe a)
    | Select (List a)

type DropdownAction a
    = OpenList
    | ClickedOption a
      
{--    
type Status
    = Normal
    | SelectFood
    | SelectCar
--}

initialModel : Model
initialModel =
    { favoriteFood = Normal Nothing
    }
    
type FoodType
    = FastFood
    | Regional
        
type alias Food =
    { id : Int
    , name : String
    , foodType : FoodType
    }


foodList : List Food
foodList =
    [ Food 0 "Hotdog" FastFood
    , Food 1 "Hamburguer" FastFood
    , Food 2 "Taco" FastFood
    , Food 3 "Francesinha aka Little French" Regional
    , Food 4 "Sauerkraut" Regional
    , Food 5 "Kimchi" Regional
    ]

    
type Msg
    = NoAction
    | FoodDropdown (DropdownAction Food)
--    | ClickedSelectCar
--    | ClickedDropdownCar Car
      

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoAction ->
            model
            
        FoodDropdown action ->
            case action of
                OpenList ->
                    { model | favoriteFood = Select foodList }
                ClickedOption food ->
                    { model | favoriteFood = Normal (Just food) }

--        ClickedSelectCar ->
--            { model | status = SelectCar }

--        ClickedDropdownCar car ->
--            { model | status = Normal, favoriteCar = Just car }                

dropdownView : Dropdown a -> (a -> String) -> (DropdownAction a -> Msg) -> E.Element Msg
dropdownView dropdownState toString toMsg =
    let
        selectedName =
            case dropdownState of
                Normal (Just someA) -> toString someA
                _ -> "Click to select"

        menu : E.Element Msg
        menu =
            case dropdownState of
                Select options ->
                    let
                        mouseOverColor : E.Color
                        mouseOverColor = E.rgb 0.9 0.9 0.1
                                         
                        backgroundColor : E.Color
                        backgroundColor = E.rgb 1 1 1
                                          
                        viewOption : a -> E.Element Msg
                        viewOption option =
                            E.el
                                [ E.width E.fill
                                , E.mouseOver [Background.color overColor]
                                , Background.color white
                                , Events.onClick (toMsg (ClickedOption option))
                                ]
                                (E.text <| toString option)
                                    
                        viewOptionList : List a -> E.Element Msg
                        viewOptionList inputOptions =
                            E.column [] <|
                                List.map viewOption inputOptions
                                            
                    in
                        E.el
                            [ Border.width 1
                            , Border.dashed
                        , E.padding 3
                        , E.below (viewOptionList options)
                        ]
                        (E.text selectedName)                
                _ ->
                    E.el
                        [ Border.width 1
                        , Border.dashed
                        , E.padding 3
                        , Events.onClick (toMsg OpenList)
                        ]
                        (E.text selectedName)
    in
        menu
    

                            
view : Model -> Html.Html Msg
view model =
    E.layout
        []
        (
        E.column
            [ E.centerX
            , E.centerY
        ]
            [ E.text "You favorite food is:"
            , dropdownView  model.favoriteFood .name FoodDropdown
            , E.text "... the best food."
--            , E.text "Favorite car:"
--            , dropdownView (model.favoriteCar == Select) model.favoriteCar carList .name ClickedSelectCar ClickedDropdownCar
            ]
        )

type alias Car = {id : Int, name: String}

overColor : E.Color
overColor = E.rgb 0.9 0.9 0.1

white : E.Color
white = E.rgb 1 1 1

        
main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
