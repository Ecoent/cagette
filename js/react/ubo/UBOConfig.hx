package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import react.ubo.vo.UBODeclarationVO;
import react.ubo.vo.UBOVO;
import react.ubo.UBOPeopleDialogForm;
import react.ubo.UBODeclarationList;
import react.ubo.UBOPeopleItemList;
import react.mui.Box;

typedef UBOConfigProps = {};

typedef UBOConfigState = {
    isLoading: Bool,
    ?declarations: Array<UBODeclarationVO>,
    // ?data: Dynamic,
    // ?peoples: Array<UBOVO>,
    ?editablePeople: UBOVO,
}; 

class UBOConfig extends ReactComponentOfPropsAndState<UBOConfigProps, UBOConfigState> {

    public function new(props: UBOConfigProps) {
        super(props);
        state = {
            isLoading: true
        };
    }

    override function componentDidMount() {
        setState({ isLoading: true });

        js.Browser.window.fetch("/api/currentgroup/mangopay/kyc/ubodeclarations")
            .then(res -> {
                if (!res.ok) {
                    throw res.statusText;
                }
                return res.json();
            }).then(res -> {
                setState({
                    isLoading: false,
                    declarations: UBODeclarationVO.parseArray(res),
                    // data: res[0],
                    // peoples: UBOVO.parseArray(res[0].Ubos)
                });
                return true;
            }).catchError(err -> {
                trace(err);
            });
    }

    override public function render() {
        // var res = 
        //     <UBOPeopleForm />
        // ;

        var res = 
            <Card>
                <CardHeader
                    title="UBO : Déclaration des bénéficiaires effectifs"
                    subheader="Liste des actionnaires détenant plus de 25% de la société"
                    />
                <CardContent>
                    {renderLoader()}
                    {renderDeclarationList()}
                    {renderDialog()}
                </CardContent>
            </Card>
        ;

        return jsx('$res');
    }

    /**
     * 
    */
    private function renderLoader() {
        if (state.isLoading) {
            return 
                <Box p={4} display="flex" justifyContent="center">
                    <CircularProgress />
                </Box>
            ;
        }
        return <></>;
    }
    
    private function renderDeclarationList() {
        if (state.isLoading) return <></>;
        if (state.declarations == null) return <div>No declaration</div>;
        return <UBODeclarationList declarations=${state.declarations} />
        ;
    }
    // private function renderCardContent() {
    //     if (state.peoples == null)  return <></>;

    //     return 
    //         <List dense>
    //         {state.peoples.map(people -> 
    //             <UBOPeopleItemList
    //                 key={people.Id}
    //                 people={people}
    //                 onEdit=$editPeople
    //             />
    //         )}
    //         </List>
    //     ;
    // }

    private function renderDialog() {
        var isOpened = state.editablePeople != null;
        return 
            <UBOPeopleDialogForm
                open={isOpened}
                people={state.editablePeople}
                onClose=$onCloseDialog
                />
        ;
    }

    private function editPeople(people: UBOVO) {
        setState({ editablePeople: people });
    }

    private function onCloseDialog(refresh: Bool) {
        setState({ editablePeople: null });
    }
}