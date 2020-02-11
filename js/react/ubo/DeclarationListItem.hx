package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.*;
import mui.core.button.IconButtonEdge;
import mui.core.button.IconButtonSize;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import react.ubo.vo.DeclarationVO;
import react.mui.CagetteTheme;
import react.mui.Alert;
import react.mui.AlertTitle;
import react.mui.Box;
import dateFns.DateFns;
import dateFns.DateFns;
import dateFns.DateFnsLocale;
import react.ubo.UBOList;
import mui.core.button.ButtonVariant;
import mui.TextColor;
import mui.core.button.ButtonSize;

typedef DeclarationListItemProps = {
    declaration: DeclarationVO,
    active: Bool,
    displayAction: Bool,
    onSelect: (?declaration: DeclarationVO) -> Void,
    onRefresh: () -> Void,
};

typedef DeclarationListItemPropsClasses = Classes<[alert, alertMessage]>;

typedef DeclarationListItemPropsWithClasses = {
    >DeclarationListItemProps,
    classes: DeclarationListItemPropsClasses,
};

typedef DeclarationListItemState = {
    confirmDialogIsOpened: Bool,
    isLoading: Bool,
    ?error: String,
};

@:publicDeclarationListItemProps(DeclarationListItemProps)
@:wrap(Styles.withStyles(styles))
class DeclarationListItem extends ReactComponentOfPropsAndState<DeclarationListItemPropsWithClasses, DeclarationListItemState> {

    public static function styles(theme:Theme):ClassesDef<DeclarationListItemPropsClasses> {
        return {
            alert: {
                flex: "1"
            },
            alertMessage: {
                width: "100%"
            }
        }
    }

    public function new(props: DeclarationListItemPropsWithClasses) {
        super(props);

        state = {
            confirmDialogIsOpened: false,
            isLoading: false,
        };
    }

    override public function render() {
        if (state.isLoading) {
            return jsx('<Box mx={2} my={4}><LinearProgress /></Box>');
        }

        var declaration = props.declaration;
        var dateStr = DateFns.format(
            Date.fromTime(declaration.CreationDate * 1000),
            'EEEE dd MMMM yyyy',
            { locale: DateFnsLocale.fr }
        );

        var listItem = switch (declaration.Status) {
            case CREATED: 
                <ListItem>
                    <Alert
                        classes={{ message: props.classes.alertMessage }} 
                        className=${props.classes.alert}
                        severity="info">
                        <AlertTitle>Complétez la déclaration.</AlertTitle>
                        {renderUboList(true, true, declaration.Ubos.length < 4)}
                        {renderSubmitButton(props.displayAction && declaration.Ubos.length > 0)}
                    </Alert>
                </ListItem>
                ;
            case VALIDATION_ASKED: 
                <ListItem>
                    <Alert
                        classes={{ message: props.classes.alertMessage }} 
                        className=${props.classes.alert}
                        severity="info">
                        <AlertTitle>Déclaration du {dateStr} en attente de validation.</AlertTitle>
                    </Alert>
                </ListItem>;
            case INCOMPLETE:
                <ListItem>
                    <Alert
                        classes={{ message: props.classes.alertMessage }}    
                        className=${props.classes.alert}
                        severity="warning">
                        <AlertTitle>Déclaration du {dateStr} incomplète.</AlertTitle>
                        {declaration.Message}<br />
                        Vous pouvez l&rsquo;éditer ci-dessous.
                        {renderUboList(true, true, declaration.Ubos.length < 4)}
                        {renderSubmitButton(props.displayAction && declaration.Ubos.length > 0)}
                    </Alert>
                </ListItem>;
            case VALIDATED:
                <ListItem>
                    <Alert
                        classes={{ message: props.classes.alertMessage }}
                        className=${props.classes.alert}
                        severity="success">
                        <AlertTitle>
                            <Box display="flex" justifyContent="space-between">
                                <Typography>Déclaration du {dateStr} acceptée.</Typography>
                                {renderAlertAction()}
                            </Box>
                        </AlertTitle>
                        {renderUboList(props.active, false, false)}
                        {renderCreateButton(props.displayAction, "Modifier")}
                    </Alert>
                </ListItem>;
            case REFUSED: 
                <ListItem>
                    <Alert 
                        className=${props.classes.alert}
                        classes={{ message: props.classes.alertMessage }}
                        severity="error">
                        <AlertTitle>
                            <Box display="flex" justifyContent="space-between">
                                <Typography>Déclaration du {dateStr} refusée.</Typography>
                                {renderAlertAction()}
                            </Box>
                        </AlertTitle>
                        {parseReason(declaration.Reason)} {declaration.Message}
                        {renderUboList(props.active, false, false)}
                    </Alert>
                </ListItem>
            ;
        };

        return jsx('
            <>
                {renderError()}
                $listItem
            </>'
        );
    }

    private function parseReason(reason: DeclarationVOReason) {
        return switch (reason) {
            case MISSING_UBO: "Ubo manquant.";
            case WRONG_UBO_INFORMATION: "Une information concernant bénéficiaire effectif est erronée.";
            case UBO_IDENTITY_NEEDED: "L'identité d'un bénéficiaire effectif est requise.";
            case SHAREHOLDERS_DECLARATION_NEEDED: "Déclaration des actionnaires requise.";
            case ORGANIZATION_CHART_NEEDED: "Organigramme requis.";
            case DOCUMENTS_NEEDED: "Documents requis.";
            case DECLARATION_DO_NOT_MATCH_UBO_INFORMATION: "La déclaration ne correspond pas avec les informations fournies.";
            case SPECIFIC_CASE: "Cas spécifique.";
        }
    }

    private function renderAlertAction() {
        if (props.active) {
            var onClick = () -> { props.onSelect(); };
            return 
                <IconButton size=${IconButtonSize.Small} onClick=$onClick>
                    <ExpandLess />
                </IconButton>
            ;
        }

        var onClick = () -> { props.onSelect(props.declaration); };
        return 
            <IconButton size=${IconButtonSize.Small} onClick=$onClick>
                <ExpandMore />
            </IconButton>
        ;
    }

    private function renderUboList(show: Bool, canEdit: Bool, canAdd: Bool) {
        if (show) {
            return 
                <Box mt={2} mx={2}>
                    <UBOList declarationId={props.declaration.Id} ubos={props.declaration.Ubos} canEdit={canEdit} canAdd={canAdd} onRefresh=${props.onRefresh} />
                </Box>
            ;
        }
        return <></>;
    }

    private function renderSubmitButton(show: Bool) {
        if (!show) return <></>;
        return 
            <Box m={2} display="flex" justifyContent="center">
                <Button
                    style={{ color: "#fff" }}
                    variant=${ButtonVariant.Contained}
                    color=${mui.Color.Secondary}
                    onClick=$openSubmitDialog>
                    Soumettre votre déclaration
                </Button>
                {renderConfirmDialog(
                    "Ces informations vont être envoyées aux équipes de Mangopay.",
                    submit
                )}
            </Box>
        ;
    }

    private function renderCreateButton(show: Bool, label: String) {
        if (!show) return <></>;
        return 
            <Box m={2} display="flex" justifyContent="center">
                <Button
                    // style={{ color: "#fff" }}
                    variant=${ButtonVariant.Outlined}
                    size=${ButtonSize.Small}
                    color=${mui.Color.Primary}
                    onClick=$openSubmitDialog>
                    {label}
                </Button>
                {renderConfirmDialog(
                    "Pour éditer une déclaration, vous allez devoir en recréer une nouvelle.",
                    create
                )}
            </Box>
        ;
    }

    private function renderConfirmDialog(message: String, confirmCallback: () -> Void) {
        return 
            <Dialog
                open=${state.confirmDialogIsOpened}
                onClose=$closeSubmitDialog
            >
                <DialogTitle>{message}</DialogTitle>
                <DialogActions>
                    <Button onClick=$closeSubmitDialog color=${mui.Color.Primary}>
                        Annuler
                    </Button>
                    <Button onClick=$confirmCallback  variant=${ButtonVariant.Outlined} color=${mui.Color.Secondary}>
                        Continuer
                    </Button>
                </DialogActions>
            </Dialog>
        ;
    }

    private function renderError() {
        if (state.error == null) return <></>;
        return 
            <Box p={2}>
                <Alert severity="error">{state.error}</Alert>
            </Box>
        ;
    }

    private function openSubmitDialog() {
        setState({ confirmDialogIsOpened: true, error: null });
    }

    private function closeSubmitDialog() {
        setState({ confirmDialogIsOpened: false });
    }

    private function submit() {
        closeSubmitDialog();
        setState({ isLoading: true, error: null });

        var url = '/api/currentgroup/mangopay/kyc/ubodeclarations/${props.declaration.Id}';
        var data = new js.html.FormData();
        data.append("Status", "VALIDATION_ASKED");

        js.Browser.window.fetch(
            url,
            {
                method: "PUT",
                body: data
            }
        ).then(res -> {
            setState({ isLoading: false });
            if (!res.ok) {
                setState({ error: "Un erreur est survenue" });
                throw res.statusText;
            }
            return res.json();
        }).then(res -> {
            props.onRefresh();
        }).catchError(err -> {
            trace(err);
        });
    }

    private function create() {
        closeSubmitDialog();
        setState({ isLoading: true, error: null });

        var url = '/api/currentgroup/mangopay/kyc/ubodeclarations';
        js.Browser.window.fetch(
            url,
            {
                method: "POST",
            }
        ).then(res -> {
            setState({ isLoading: false });
            if (!res.ok) {
                setState({ error: "Un erreur est survenue" });
                throw res.statusText;
            }
            return res.json();
        }).then(res -> {
            props.onRefresh();
        }).catchError(err -> {
            trace(err);
        });
    }
}
