//
//  SingleListTableViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "SingleListTableViewController.h"
#import "AddItemViewController.h"
#import "Item+CoreDataClass.h"
@interface SingleListTableViewController (){
    NSArray *sortedNameArray;
    NSArray *sortedCategoryArray;
}

@end

@implementation SingleListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Item"];
    
    self.items = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
   
    //NSLog(@" %@",_listName);
    //NSLog(@"\n\n%@\n\n",[self.items valueForKey:@"itemName"]);
    [self localizeItemsInSortedArray];
    
     [self.tableView reloadData];
}

- (IBAction)saveAndGoBack:(UIBarButtonItem *)sender {
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int displayCount = 0;
    //[[self.items valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]
   /* if ([self.items count]==0)
    {
        Item *anItem = [[Item alloc]initWithContext:context];
        [anItem setValue:@"Apples" forKey:@"itemName"];
        [anItem setValue:@"Produce" forKey:@"itemCategory"];
        [anItem setValue:[self.listName valueForKey:@"listName"] forKey:@"listName"];
        [self.items addObject:anItem];
        //    NSLog(@"%@",anItem);
    }*/
    for(int i=0; i < [self.items count]; i++) {
        if ([[self.items[i] valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {
        displayCount++;}
        NSLog(@"items in list: %d",displayCount);}
    return displayCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SingleListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
   // NSString * itemListName = [NSString stringWithFormat:@"%@",self.listName];
  //  NSLog(@"The list name is: %@",[self.listName valueForKey:@"listName"]);
    NSManagedObjectModel *anItem = [self.items objectAtIndex:indexPath.row];
    if ([[anItem valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {
         
    cell.textLabel.text = [anItem valueForKey:@"itemName"];
    cell.detailTextLabel.text = [anItem valueForKey:@"itemCategory"];
    }
  //  NSLog(@"%@ - %@ - %@",[anItem valueForKey:@"itemName"],[anItem valueForKey:@"itemCategory"],[anItem valueForKey:@"listName"]);
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.items count] > 1)
        return YES;
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.items objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
        
        //delete row from memory object
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
   
}

-(void)localizeItemsInSortedArray {
    NSMutableArray *mutNameArray = [[NSMutableArray alloc]init];
    NSMutableArray *mutCatArray = [[NSMutableArray alloc]init];
    sortedCategoryArray = [[NSArray alloc]init];
    sortedNameArray = [[NSArray alloc]init];
    
    NSMutableArray *justTheRightOnes = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self.items count]; i++){
        NSManagedObjectModel *anItem = [self.items objectAtIndex:i];
        if ([[anItem valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {
            [justTheRightOnes addObject:anItem];
             [mutCatArray addObject:[anItem valueForKey:@"itemCategory"]];
        }
    }
    sortedCategoryArray= [mutCatArray sortedArrayUsingSelector:@selector(compare:)];
   // NSLog(@"%@",sortedCategoryArray);
    NSMutableArray  *tempCatArray = [[NSMutableArray alloc]initWithArray:sortedCategoryArray];
   
    NSLog(@"%luld",[justTheRightOnes count]);
    for (NSUInteger i = 0; i< [justTheRightOnes count]; i++){
        NSManagedObjectModel *anItem = [justTheRightOnes objectAtIndex:i];
        
            if([[anItem valueForKey:@"itemCategory"] isEqualToString:[tempCatArray objectAtIndex:i]]){
                
                [mutNameArray addObject:[anItem valueForKey:@"itemName"]];
                [tempCatArray removeObjectAtIndex:i];
                i = 0;
            }
        
    }
    sortedNameArray = [mutNameArray copy];
    NSLog(@"%@ : %@\n",sortedCategoryArray,sortedNameArray);
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddItemViewController *updateItemView = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"editItemInfo"]) {
        NSManagedObjectModel *selectedItem = [self.items objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        updateItemView.anItem = selectedItem;
        updateItemView.listName = self.listName;
        NSLog(@"%@",self.listName);
    } else if ([[segue identifier] isEqualToString:@"addItemInfo"])   {
        updateItemView.listName = self.listName;
    }
}



@end
