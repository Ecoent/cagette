import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { CagettePro } from "./CagettePro";
import { Vendor } from "./Vendor";
import { PCatalogOffer } from "./PCatalogOffer";

@Index("PCatalog_companyId", ["companyId"], {})
@Index("PCatalog_vendorId", ["vendorId"], {})
@Entity("PCatalog", { schema: "db" })
export class PCatalog {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("int", { name: "maxDistance", nullable: true })
  maxDistance: number | null;

  @Column("int", { name: "companyId" })
  companyId: number;

  @Column("mediumblob", { name: "deliveryAvailabilities", nullable: true })
  deliveryAvailabilities: Buffer | null;

  @Column("date", { name: "endDate" })
  endDate: string;

  @Column("date", { name: "startDate" })
  startDate: string;

  @Column("datetime", { name: "lastUpdate" })
  lastUpdate: Date;

  @Column("varchar", { name: "contractName", nullable: true, length: 128 })
  contractName: string | null;

  @Column("int", { name: "vendorId", nullable: true })
  vendorId: number | null;

  @Column("tinyint", { name: "visible", width: 1 })
  visible: boolean;

  @OneToMany(
    () => CagettePro,
    cagettePro => cagettePro.demoCatalog
  )
  cagettePros: CagettePro[];

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.pCatalogs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => Vendor,
    vendor => vendor.pCatalogs,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "vendorId", referencedColumnName: "id" }])
  vendor: Vendor;

  @OneToMany(
    () => PCatalogOffer,
    pCatalogOffer => pCatalogOffer.catalog
  )
  pCatalogOffers: PCatalogOffer[];
}
