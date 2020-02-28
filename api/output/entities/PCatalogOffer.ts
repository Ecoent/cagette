import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { PCatalog } from "./PCatalog";
import { POffer } from "./POffer";

@Index("PCatalogOffer_catalogId", ["catalogId"], {})
@Entity("PCatalogOffer", { schema: "db" })
export class PCatalogOffer {
  @Column("double", { name: "price", precision: 22 })
  price: number;

  @Column("int", { primary: true, name: "offerId" })
  offerId: number;

  @Column("int", { primary: true, name: "catalogId" })
  catalogId: number;

  @ManyToOne(
    () => PCatalog,
    pCatalog => pCatalog.pCatalogOffers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "catalogId", referencedColumnName: "id" }])
  catalog: PCatalog;

  @ManyToOne(
    () => POffer,
    pOffer => pOffer.pCatalogOffers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "offerId", referencedColumnName: "id" }])
  offer: POffer;
}
