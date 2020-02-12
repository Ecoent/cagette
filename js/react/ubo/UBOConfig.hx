package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.Color;
import mui.core.*;
import mui.core.button.ButtonVariant;
import mui.core.button.IconButtonSize;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import react.ubo.vo.DeclarationVO;
import react.ubo.vo.UboVO;
import react.ubo.DeclarationList;
import react.mui.Box;
import react.mui.Alert;
import react.ubo.Provider;
import react.ubo.DeclarationsHistory;
import react.common.FormDialog;
import react.ubo.components.Declaration;
import react.ubo.components.UboForm;
import react.ubo.Api;
import react.ubo.Utils;

private typedef Props = {};

private typedef State = {
    historyIsCollapsed: Bool,
    declarationIsLoading: Bool,
    ?currentDeclaration: DeclarationVO,
    ?oldDeclarations: Array<DeclarationVO>,

    ?error: String, 

    formIsSubmitting: Bool,
    formDialogIsOpened: Bool,
    formValueIsEditable: Bool,
    ?formValue: UboVO,

    ?countrys: Array<{alpha2: String, nationality: String, country: String}>,
}; 

class UBOConfig extends ReactComponentOfPropsAndState<Props, State> {

    public function new(props: Props) {
        super(props);
        state = {
            declarationIsLoading: false,
            
            historyIsCollapsed: true,

            formIsSubmitting: false,
            formDialogIsOpened: false,
            formValueIsEditable: false,
        };
    }

    override function componentDidMount() {
        loadDatas();

        Api.fetchISO3166French().then(res -> {
            setState({ countrys: cast res });
        });
    }

    override public function render() {
        var res = 
            <Card>
                <CardHeader
                    title="Déclaration des bénéficiaires effectifs (UBO)"
                    subheader="Liste des actionnaires détenant plus de 25% de la société"
                    />
                <CardContent>
                    {renderError()}
                    {renderCardContent()}
                </CardContent>
            </Card>
        ;

        return jsx('$res');
    }

    /**
     *
     */
    private function renderCardContent() {
        if (state.declarationIsLoading) {
            return renderLoader();
        } else if (state.currentDeclaration == null) {
            return <>{renderSubmitDeclarationButton()}</>;
        } else {
            var canSubmit = Utils.declaration(state.currentDeclaration).canBeSubmitted() && state.currentDeclaration.Ubos.length > 0;
            var submitButton = canSubmit ? renderSubmitDeclarationButton() : <></>;
            var createButton = Utils.declaration(state.currentDeclaration).canCreateNew() ? renderCreateDeclarationButton() : <></>;
            return
                <>
                    <Declaration expend={true} declaration={state.currentDeclaration} onAddClick=$addUbo onEditClick=$editUbo onViewClick=$viewUbo />
                    {submitButton}
                    {createButton}
                    {renderHistory()}
                    {renderFormDialog()}
                </>
            ;
        }
    }

    private function renderHistory() {
        if (state.oldDeclarations == null || state.oldDeclarations.length == 0) return <></>;

        var icon = state.historyIsCollapsed  ? <ExpandMore /> : <ExpandLess />;

        return 
            <>
                <Box my={2} display="flex" justifyContent="space-between" alignItems="center">
                    <ListItem>
                        <ListItemText primary="Historique des déclarations" />
                        <IconButton size=${IconButtonSize.Small} onClick=$toggleHistory>
                            {icon}
                        </IconButton>
                    </ListItem>
                </Box>
                <Collapse in={!state.historyIsCollapsed}>
                    <>
                        {state.oldDeclarations.map(d -> 
                            <Box key={d.Id} my={2}>
                                <Declaration isOld={true} declaration={d} onViewClick=$viewUbo />
                            </Box>
                        )}
                    </>
                </Collapse>
            </>
        ;
    }

    private function renderFormDialog() {
        var open = state.formDialogIsOpened;
        var dialogContent = state.countrys == null ? renderLoader() : <UboForm ubo={state.formValue} countrys={state.countrys} canEdit={state.formValueIsEditable} onSubmit=$onUboFormSubmit />;
        
        return 
            <FormDialog
                open=$open
                title="Bénéficiaire effectif (UBO)"
                loading={state.formIsSubmitting}
                onClose=$closeFormDialog>
                {dialogContent}
            </FormDialog>
        ;
    }

    private function renderSubmitDeclarationButton() {
        return
            <Box m={2} display="flex" justifyContent="center">
                <Button style={{ color: "#fff" }}
                    variant={ButtonVariant.Contained}
                    color={Color.Secondary}
                    onClick=$submitDeclaration>
                    Soumettre votre déclaration
                </Button>
            </Box>
            ;
    }

    private function renderCreateDeclarationButton() {
        return
            <Box m={2} display="flex" justifyContent="center">
                <Button style={{ color: "#fff" }}
                    variant={ButtonVariant.Contained}
                    color={Color.Secondary}
                    onClick=$createDeclaration>
                    Créer une nouvelle déclaration
                </Button>
            </Box>
            ;
    }

    private function renderLoader() {
        return <Box display="flex" py={4} justifyContent="center"><CircularProgress /></Box>;
    }

    private function renderError() {
        if (state.error == null) return <></>;
        return
            <Box py={2}>
                <Alert severity="error">{state.error}</Alert>
            </Box>
        ;
    }

    /**
     * 
     */
    private function toggleHistory() {
        setState({ historyIsCollapsed: !state.historyIsCollapsed });
    }

    private function addUbo() {
        setState({ formDialogIsOpened: true, formValue: null, formValueIsEditable: true });
    }

    private function editUbo(ubo: UboVO) {
        setState({ formDialogIsOpened: true, formValue: ubo, formValueIsEditable: true });
    }

    private function viewUbo(ubo: UboVO) {
        setState({ formDialogIsOpened: true, formValue: ubo, formValueIsEditable: false });
    }

    private function closeFormDialog() {
        setState({ formDialogIsOpened: false, formValue: null, formValueIsEditable: false });
    }

    private function createDeclaration() {
        setState({ declarationIsLoading: true , error: null });
        
        Api.createDeclaration()
            .then(res -> {
                setState({ declarationIsLoading: true });
                loadDatas();
            }).catchError(err -> {
                setState({ declarationIsLoading: false, error: "Un erreur est survenue." });
            });
    }

    private function submitDeclaration() {
        setState({ declarationIsLoading: true , error: null });
        
        Api.updateDeclaration(state.currentDeclaration.Id)
            .then(res -> {
                setState({ declarationIsLoading: true });
                loadDatas();
            }).catchError(err -> {
                setState({ declarationIsLoading: false, error: "Un erreur est survenue." });
            });
    }

    private function onUboFormSubmit(?uboId: Int, data: js.html.FormData, formikBag: Dynamic) {
        setState({ formIsSubmitting: true });

        Api.postOrPutUbo(data, state.currentDeclaration.Id, uboId)
            .then(res -> {
                formikBag.setSubmitting(false);
                setState({ formIsSubmitting: false });
                closeFormDialog();
                loadDatas();
            }).catchError(err -> {
                formikBag.setSubmitting(false);
                formikBag.setStatus("Un erreur est survenue");
                setState({ formIsSubmitting: false });
            });
    }

    /**
     * 
    */
    private function loadDatas() {
        setState({ declarationIsLoading: true });

        Api.fetchDeclarations()
            .then(res -> {
                var current;
                var olds;
                var declarations = DeclarationVO.parseArray(res);

                var ds = declarations.map(d -> d);
                ds.sort((a, b) ->  a.CreationDate - b.CreationDate);

                if (ds.length > 0) {
                    current = ds.pop();
                }
                olds = ds;

                setState({
                    declarationIsLoading: false,
                    currentDeclaration: current,
                    oldDeclarations: olds,
                });
                return true;
            }).catchError(err -> {
                trace(err);
            });
    }
}